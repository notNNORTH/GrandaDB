/*
  用Explain关键字执行关系、图、向量以及文档的跨模查询语句，验证查询计划中是否有相应四个模型的算子
*/

-- 此处可以使用M2Bench中Task11.sql来进行检查
SELECT time, coordinates INTO TEMPORARY TABLE eqk_x FROM earthquake WHERE earthquake_id=44340;
-- 先把所有类型为路节点的site选出来
create temporary table site_roadnode as(
  select site.data, replace(Site.data->'geometry'->>'coordinates','"','')::vector(2) as v_site_geo
  from site
  WHERE site.data->'properties'->>'type'='roadnode'
);
-- 并建立索引，加速后面的向量距离查询
CREATE INDEX site_roadnode_vector_idx ON site_roadnode USING ivfflat(v_site_geo vector_l2_ops) with(lists=1600);

explain WITH A AS (
    SELECT gps.gps_id, gps.coordinates, ('[' || ST_X(gps.coordinates) || ', ' || ST_Y(gps.coordinates) || ']')::vector(2) AS v_coordinates
    FROM gps, eqk_x
    WHERE gps.time >= eqk_X.time AND gps.time < eqk_X.time + interval '1 hour' AND ST_DWithin(gps.coordinates::geography, eqk_x.coordinates::geography, 10000, false)
),
gps_nodes AS (
    SELECT t1.gps_id AS gps_id,(
        SELECT (site.data->>'site_id')::int AS site_id
        FROM site_roadnode as Site
        -- ORDER BY ST_Distance(ST_GeomFromGeoJSON(site.data->>'geometry'), (t1.coordinates)::geography) ASC 
        ORDER BY site.v_site_geo <-> t1.v_coordinates
        LIMIT 1 
    ) AS roadnode_id
    FROM A t1
),
B AS (
    SELECT shelter.shelter_id, ST_GeomFromGeoJSON(site_centroid.data->>'centroid') AS centroid, replace(site_centroid.data->'centroid'->>'coordinates','"','')::vector(2) AS v_centroid
    FROM eqk_x, shelter, site_centroid
    WHERE shelter.site_id = (site_centroid.data->>'site_id')::int 
    AND ST_DWithin(eqk_x.coordinates::geography, ST_GeomFromGeoJSON(site_centroid.data->>'centroid')::geography, 15000, false)
),
shelter_nodes AS (
    SELECT t1.shelter_id as shelter_id ,(
        SELECT (site.data->>'site_id')::int AS site_id
        from site_roadnode as Site
        -- ORDER BY ST_Distance(ST_GeomFromGeoJSON(Site.data->>'geometry'), (t1.centroid)::geography) ASC 
        ORDER BY site.v_site_geo <-> t1.v_centroid
        LIMIT 1
    ) AS roadnode_id
    FROM B t1
)

SELECT COUNT(*) FROM (
    SELECT src.gps_id AS src, dest.shelter_id AS dest, SUM(e.weight) AS distance
    FROM gps_nodes AS src, shelter_nodes AS dest,
    road_network MATCH{SHORTEST path = (n: roadnode)-[e: road]{1,15}->(m: roadnode)}
    WHERE (n.site_id)::INT = src.roadnode_id 
    AND (m.site_id)::INT = dest.roadnode_id 
    GROUP BY src, dest
) as C;