\c ecommerce;
-- social_network
COPY person FROM '/tmp/m2bench/ecommerce/property_graph/person_node_gs.csv' DELIMITER ',' CSV HEADER;
CREATE TEMP TABLE follows_temp (
    startid BIGINT,
    endid BIGINT,
    properties JSONB
);
COPY follows_temp (startid, endid, properties)
FROM '/tmp/m2bench/ecommerce/property_graph/person_follows_person_gs.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

INSERT INTO follows (startid, startlabelid, endid, endlabelid, properties)
SELECT 
    t.startid,
    'person'::regclass::oid AS startlabelid,  
    t.endid,
    'person'::regclass::oid AS endlabelid, 
    t.properties
FROM follows_temp t;

-- tag_network
COPY tag FROM '/tmp/m2bench/ecommerce/property_graph/hashtag_node_gs.csv' DELIMITER ',' CSV HEADER;
CREATE TEMP TABLE interested_in_temp (
    startid BIGINT,
    endid BIGINT,
    properties JSONB
);
COPY interested_in_temp (startid, endid, properties)
FROM '/tmp/m2bench/ecommerce/property_graph/person_interestedIn_tag_gs.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

INSERT INTO interested_in (startid, startlabelid, endid, endlabelid, properties)
SELECT 
    t.startid,
    'person'::regclass::oid AS startlabelid,
    t.endid,
    'tag'::regclass::oid AS endlabelid,
    t.properties
FROM interested_in_temp t;

select load_graph('social_network'::regclass::bigint);
select load_graph('tag_network'::regclass::bigint);