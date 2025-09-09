LOAD spatial;

COPY Site (data) 
FROM '/tmp/m2bench/disaster/json/Site.json'
(FORMAT JSON);

COPY Site_centroid (data)
FROM '/tmp/m2bench/disaster/json/Site_centroid_mod_clean.json'
(FORMAT JSON);

-- CREATE TABLE Site_centroid AS
-- SELECT CAST(v AS JSON) AS data
-- FROM Site_centroid_raw;
-- DROP TABLE IF EXISTS Site_centroid_raw;

ALTER TABLE Site ADD COLUMN geometry GEOMETRY;
UPDATE Site 
SET geometry = ST_GeomFromGeoJSON(json_extract(data, '$.geometry'));

ALTER TABLE Site_centroid ADD COLUMN centroid GEOMETRY;
UPDATE Site_centroid
SET centroid = ST_GeomFromGeoJSON(json_extract(data, '$.centroid'));

CREATE INDEX Site_geometry_idx ON Site(geometry);
-- CREATE UNIQUE INDEX Site_id_idx 
--     ON Site(CAST(json_extract_string(data, '$.site_id') AS INT));
-- CREATE INDEX Site_type_idx ON Site((json_extract_string(data, '$.properties.type')));

CREATE INDEX Site_centroid_geometry_idx ON Site_centroid(centroid);
-- CREATE UNIQUE INDEX Site_centroid_id_idx 
    -- ON Site_centroid(CAST(json_extract_string(data, '$.site_id') AS INT));
-- CREATE INDEX Site_centroid_type_idx ON Site_centroid((json_extract_string(data, '$.properties.type')));