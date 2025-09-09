LOAD spatial;


COPY Earthquake(earthquake_id, time, latitude, longitude, depth, magnitude) 
FROM '/tmp/m2bench/disaster/table/Earthquake.csv' 
(FORMAT CSV, HEADER, DELIMITER ',');


UPDATE Earthquake 
SET coordinates = ST_Point(longitude, latitude);

-- DuckDB do not support GIST
CREATE INDEX Earthquake_coordinates_idx ON Earthquake(coordinates);


-- ALTER TABLE Earthquake DROP COLUMN latitude;
-- ALTER TABLE Earthquake DROP COLUMN longitude;


COPY Shelter FROM '/tmp/m2bench/disaster/table/Shelter.csv' 
(FORMAT CSV, HEADER, DELIMITER '|');


COPY Gps(gps_id, user_id, longitude, latitude, time) 
FROM '/tmp/m2bench/disaster/table/Gps.csv' 
(FORMAT CSV, HEADER, DELIMITER ',');


UPDATE Gps 
SET coordinates = ST_Point(longitude, latitude);


CREATE INDEX Gps_coordinates_idx ON Gps(coordinates);


-- ALTER TABLE Gps DROP COLUMN latitude;
-- ALTER TABLE Gps DROP COLUMN longitude;


CREATE INDEX Earthquake_magnitude_id ON Earthquake(magnitude);
