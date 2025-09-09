LOAD duckpgq;


DROP TABLE IF EXISTS Roadnodes;
DROP TABLE IF EXISTS Roads;
DROP PROPERTY GRAPH IF EXISTS Road_network;


CREATE TABLE Roadnodes (
    roadnode_id INT PRIMARY KEY,
    site_id INT
);

CREATE TABLE Roads (
    _from INT,
    _to INT,
    distance INT
);


COPY Roadnodes FROM '/tmp/m2bench/disaster/property_graph/Roadnode.csv' (FORMAT CSV, HEADER, DELIMITER ',');
COPY Roads FROM '/tmp/m2bench/disaster/property_graph/Road.csv' (FORMAT CSV, HEADER, DELIMITER ',');


CREATE PROPERTY GRAPH Road_network
VERTEX TABLES (
    Roadnodes
)
EDGE TABLES (
    Roads SOURCE KEY (_from) REFERENCES Roadnodes(roadnode_id)
          DESTINATION KEY (_to) REFERENCES Roadnodes(roadnode_id)
);
