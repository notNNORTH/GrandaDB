\c disaster
  
COPY Site (data) FROM '/tmp/m2bench/disaster/json/Site_mod.json';
CREATE INDEX Site_geometry_idx ON Site USING GIST(ST_GeomFromGeoJSON(data ->> 'geometry'));
CREATE UNIQUE INDEX Site_id_idx ON Site USING btree (((data->>'site_id')::int));
CREATE INDEX Site_type_idx On Site USING btree (((data->'properties'->>'type')::text));


COPY Site_centroid (data) FROM '/tmp/m2bench/disaster/json/Site_centroid_mod.json';
CREATE INDEX Site_centroid_geometry_idx ON Site_centroid USING GIST((ST_GeomFromGeoJSON(data ->> 'centroid')::geography));
CREATE UNIQUE INDEX Site_centroid_id_idx ON Site_centroid USING btree (((data->>'site_id')::int));
CREATE INDEX Site_centroid_type_idx On Site_centroid USING btree (((data->'properties'->>'type')::text));
