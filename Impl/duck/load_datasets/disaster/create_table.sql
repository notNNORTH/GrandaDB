INSTALL spatial;
LOAD spatial;

DROP TABLE IF EXISTS Earthquake;
DROP TABLE IF EXISTS Shelter;
DROP TABLE IF EXISTS Gps;

CREATE TABLE Earthquake (
    earthquake_id INTEGER PRIMARY KEY,
    time TIMESTAMP,
    coordinates GEOMETRY,
    latitude DOUBLE,
    longitude DOUBLE,
    depth DOUBLE,
    magnitude DOUBLE
);

CREATE TABLE Shelter (
    shelter_id INTEGER PRIMARY KEY,
    site_id INTEGER,
    capacity DOUBLE,
    name VARCHAR(100)
);

CREATE TABLE Gps (
    gps_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    coordinates GEOMETRY,
    longitude DOUBLE,
    latitude DOUBLE,
    time TIMESTAMP
);
