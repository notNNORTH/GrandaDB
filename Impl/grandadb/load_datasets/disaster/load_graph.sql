\c disaster
COPY roadnode FROM '/tmp/m2bench/disaster/property_graph/Roadnode_gs.csv' DELIMITER ',' CSV HEADER;
CREATE TEMP TABLE road_temp (
    startid BIGINT,
    endid BIGINT,
    properties JSONB
);
COPY road_temp (startid, endid, properties)
FROM '/tmp/m2bench/disaster/property_graph/Road_gs.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

INSERT INTO road (startid, startlabelid, endid, endlabelid, properties)
SELECT 
    t.startid,
    'roadnode'::regclass::oid AS startlabelid,
    t.endid,
    'roadnode'::regclass::oid AS endlabelid,
    t.properties
FROM road_temp t;

select load_graph('road_network'::regclass::bigint);