
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS follows;
DROP TABLE IF EXISTS hashtag;
DROP TABLE IF EXISTS interested_in;

LOAD duckpgq;


CREATE TABLE person(
    person_id INTEGER,
    gender CHAR(1),
    date_of_birth DATE,
    firstname VARCHAR(20),
    lastname VARCHAR(20),
    nationality VARCHAR(20),
    email VARCHAR(50)
);

CREATE TABLE hashtag(
    tag_id INTEGER,
    content VARCHAR(30)
);


CREATE TABLE follows(
    _from INTEGER,
    _to INTEGER,
    created_time TIMESTAMP
);

CREATE TABLE interested_in(
    _from INTEGER,
    _to INTEGER,
    created_time CHAR(20)
);


COPY person FROM '/tmp/m2bench/ecommerce/property_graph/person_node.csv' (FORMAT CSV, HEADER, DELIMITER '|');
COPY follows FROM '/tmp/m2bench//ecommerce/property_graph/person_follows_person.csv' (FORMAT CSV, HEADER, DELIMITER '|');
COPY hashtag FROM '/tmp/m2bench/ecommerce/property_graph/hashtag_node.csv' (FORMAT CSV, HEADER, DELIMITER ',');
COPY interested_in FROM '/tmp/m2bench/ecommerce/property_graph/person_interestedIn_tag.csv' (FORMAT CSV, HEADER, DELIMITER ',');


DROP PROPERTY GRAPH IF EXISTS social_network;

CREATE PROPERTY GRAPH social_network
  VERTEX TABLES (
    person,
    hashtag
  )
  EDGE TABLES (
    follows SOURCE KEY (_from) REFERENCES person (person_id) DESTINATION KEY (_to) REFERENCES person (person_id),
    interested_in SOURCE KEY (_from) REFERENCES person (person_id) DESTINATION KEY (_to) REFERENCES hashtag (tag_id)
  );
