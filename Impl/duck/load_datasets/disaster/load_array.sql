
COPY Finedust FROM '/tmp/m2bench/disaster/array/Finedust.csv' (DELIMITER ',', HEADER);


CREATE INDEX Finedust_timestamp_idx ON Finedust(timestamp);
CREATE INDEX Finedust_latitude_idx ON Finedust(latitude);
-- CREATE INDEX Finedust_longitude_idx ON Finedust(longitude);


COPY Finedust_idx FROM '/tmp/m2bench/disaster/array/Finedust_idx.csv' (DELIMITER ',', HEADER);


CREATE INDEX Finedust_idx_timestamp_idx ON Finedust_idx(timestamp);
-- CREATE INDEX Finedust_idx_composite_idx ON Finedust_idx(timestamp, latitude, longitude);
-- CREATE INDEX Finedust_idx_coo_idx ON Finedust_idx(latitude, longitude);
