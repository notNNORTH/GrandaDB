\timing

CREATE TEMPORARY TABLE site_roadnode AS(
  SELECT data, (data->>'site_id'::TEXT)::INT AS site_id, ST_GeomFromGeoJSON(data->>'geometry')::geography AS site_geo
  FROM site
  WHERE site.data->'properties'->>'type'='roadnode'
);

CREATE INDEX site_roadnode_geometry_idx ON site_roadnode USING GIST(site_geo);

CREATE TEMPORARY TABLE eqk AS(
    SELECT earthquake_id, time, coordinates FROM earthquake
    WHERE time >= to_timestamp('2020-06-01 00:00:00' , 'YYYY-MM-DD HH24:MI:SS') AND time < to_timestamp('2020-06-01 02:00:00', 'YYYY-MM-DD HH24:MI:SS')
);

CREATE TEMPORARY TABLE roadnodes AS (
    SELECT eqk.earthquake_id AS eqk_id, site_roadnode.site_id AS site_id
    FROM site_roadnode, eqk
    WHERE ST_DWithin(site_roadnode.site_geo, eqk.coordinates::geography, 5000, false)
);

SELECT COUNT(*) FROM (
    SELECT distinct n.id,m.id
    FROM roadnodes AS src,
        Road_network
            MATCH {(n : roadnode)-[r : road]->(m : roadnode)}
            WHERE (n.site_id)::integer = src.site_id
) as A;