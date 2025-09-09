DROP TABLE IF EXISTS Disease;
DROP TABLE IF EXISTS Is_a;

LOAD duckpgq;

DROP PROPERTY GRAPH IF EXISTS disease_network;


CREATE TABLE Disease (
    disease_id BIGINT PRIMARY KEY,
    term VARCHAR(10000)
);


CREATE TABLE Is_a (
    source_id BIGINT,
    label VARCHAR(10),
    destination_id BIGINT
);

COPY Disease FROM '/tmp/m2bench/healthcare/property_graph/Disease_network_nodes.csv'
    (FORMAT CSV, HEADER, DELIMITER ',', QUOTE '"', ESCAPE '"', STRICT_MODE FALSE);

COPY Is_a FROM '/tmp/m2bench/healthcare/property_graph/Disease_network_edges.csv'
    (FORMAT CSV, HEADER, DELIMITER ',');


CREATE PROPERTY GRAPH disease_network
VERTEX TABLES (
    Disease
)
EDGE TABLES (
    Is_a SOURCE KEY (source_id) REFERENCES Disease(disease_id)
         DESTINATION KEY (destination_id) REFERENCES Disease(disease_id)
);

-- test  whether you load successfully or not
-- SELECT *
-- FROM GRAPH_TABLE (
--   disease_network
--   MATCH (a:Disease)-[k:is_a]->(b:Disease)
--   COLUMNS (a.disease_id, b.disease_id)
-- )
-- LIMIT 1;
