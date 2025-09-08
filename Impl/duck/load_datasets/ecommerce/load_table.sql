COPY brand 
FROM '/tmp/m2bench/ecommerce/table/Brand.csv' 
(FORMAT CSV, HEADER, DELIMITER ',');

COPY product 
FROM '/tmp/m2bench/ecommerce/table/Product.csv' 
(FORMAT CSV, HEADER, DELIMITER ',');

COPY customer 
FROM '/tmp/m2bench/ecommerce/table/Customer.csv' 
(FORMAT CSV, HEADER, DELIMITER '|');