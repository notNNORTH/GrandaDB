
DROP TABLE IF EXISTS "order";
DROP TABLE IF EXISTS review;

-- duckdb do not support any types of json index

CREATE TABLE "order" AS
SELECT * 
FROM read_ndjson_objects('/tmp/m2bench/ecommerce/json/order.json', format='newline_delimited');

CREATE TABLE review AS
SELECT * 
FROM read_ndjson_objects('/tmp/m2bench/ecommerce/json/review.json', format='newline_delimited');