  
DROP TABLE IF EXISTS Finedust;
DROP TABLE IF EXISTS Finedust_idx;

CREATE TABLE Finedust (
    timestamp INT,
    latitude DOUBLE,
    longitude DOUBLE,
    pm10 DOUBLE,
    pm2_5 DOUBLE
);

CREATE TABLE Finedust_idx (
    timestamp INT,
    latitude INT,
    longitude INT,
    pm10 DOUBLE,
    pm2_5 DOUBLE
);
