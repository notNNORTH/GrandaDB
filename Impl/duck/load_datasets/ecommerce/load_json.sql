-- Duckddb do not support indices on json type data

COPY "order" FROM '/tmp/m2bench/ecommerce/json/order.json' (FORMAT 'json');
-- CREATE INDEX order_customer_id_idx 
--     ON "order"(json_extract(data, '$.customer_id'));
-- CREATE INDEX order_order_id_idx 
--     ON "order"(json_extract(data, '$.order_id'));
-- CREATE INDEX order_orderline_product_id_idx 
--     ON "order"(json_extract(data, '$.order_line.product_id'));
-- CREATE INDEX order_orderline_idx 
--     ON "order"(json_extract(data, '$.order_line'));



COPY review FROM '/tmp/m2bench/ecommerce/json/review.json' (FORMAT 'json');
-- CREATE INDEX review_order_id_idx 
--     ON review(json_extract(data, '$.order_id'));
-- CREATE INDEX review_product_id_idx 
--     ON review(json_extract(data, '$.product_id'));


-- CREATE INDEX review_rating_idx 
--     ON review(CAST(json_extract(data, '$.rating') AS INTEGER));
-- CREATE INDEX review_rating_order_id_idx 
--     ON review(
--         CAST(json_extract(data, '$.rating') AS INTEGER),
--         json_extract(data, '$.order_id')
--     );
