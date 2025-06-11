\timing

-- 先把所有类型为路节点的site选出来
create temporary table site_roadnode as(
  select site.data, replace(Site.data->'geometry'->>'coordinates','"','')::vector(2) as v_site_geo
  from site
  WHERE site.data->'properties'->>'type'='roadnode'
);
-- 并建立索引，加速后面的向量距离查询
CREATE INDEX site_roadnode_vector_idx ON site_roadnode USING ivfflat(v_site_geo vector_l2_ops) with(lists=1600);

WITH A AS (
  SELECT shelter.shelter_id,  replace(site_centroid.data->'centroid'->>'coordinates','"','')::vector(2) AS v_centroid, ST_GeomFromGeoJSON(site_centroid.data->>'centroid') AS centroid, COUNT(gps.gps_id) AS numGps
  FROM shelter, site_centroid, gps
  WHERE gps.time >= to_timestamp('2020-09-17 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AND gps.time < to_timestamp('2020-09-17 01:00:00' , 'YYYY-MM-DD HH24:MI:SS') AND (site_centroid.data->>'site_id')::int = shelter.site_id AND site_centroid.data->'properties'->>'type'='building' AND site_centroid.data->'properties'->>'description'='hospital'
  AND ST_DWithin(ST_GeomFromGeoJSON(site_centroid.data->>'centroid')::geography, gps.coordinates::geography, 5000, false)
  GROUP BY shelter.shelter_id, centroid, v_centroid
  ORDER BY numGps DESC
  LIMIT 1
),  -- gps信号最多的避难所
B AS (
  SELECT A.shelter_id as shelter_id, A.centroid as shelter_geom, (    -- 只有写成这种标量子查询的形式，才能用到向量索引
    select (Site.data->>'site_id')::INT
    from site_roadnode as Site
    ORDER BY site.v_site_geo <-> A.v_centroid
    -- ORDER BY ST_GeomFromGeoJSON(Site.data->>'geometry') <-> (A.centroid)::geography ASC
    LIMIT 1
  ) AS roadnode_id
  FROM A
),  -- 离这个避难所最近的路节点
filtered_buildings AS (
  SELECT (site_centroid.data->>'site_id')::INT AS building_id,replace(site_centroid.data->'centroid'->>'coordinates','"','')::vector(2) AS v_centroid, ST_GeomFromGeoJSON(site_centroid.data->>'centroid') AS centroid
  FROM B, site_centroid 
  WHERE site_centroid.data->'properties'->>'type'='building' 
  AND site_centroid.data->'properties'->>'description'='school' 
  AND ST_DWithin(ST_GeomFromGeoJSON(site_centroid.data->>'centroid')::geography, B.shelter_geom::geography, 1000, false)
),  -- 离这个避难所1km之内的学校建筑物
C AS (
    SELECT t1.building_id AS building_id,(
        select (Site.data->>'site_id')::INT
        from site_roadnode as Site
        ORDER BY site.v_site_geo <-> t1.v_centroid 
        LIMIT 1
    ) AS roadnode_id
    FROM filtered_buildings t1
)   -- 离这些学校建筑物最近的路节点
SELECT COUNT(*) FROM (
  SELECT d, SUM(distance) AS sum_distance
  FROM (
    SELECT src.roadnode_id, dest.building_id AS d, 
          CASE WHEN e.weight IS NULL THEN 0 ELSE e.weight::INT END AS distance
    FROM Road_network MATCH {SHORTEST path = (n: roadnode)-[e: road]{1,15}->(m: roadnode)},
          B AS src, C AS dest
    WHERE n.site_id = src.roadnode_id
    AND m.site_id = dest.roadnode_id
  ) AS shelter_building_pair
  GROUP BY d
  ORDER BY SUM(distance), d
  LIMIT 5
) as D;   -- 计算避难所路节点到每个建筑物路节点的最短距离，取前5个，作为新避难所

