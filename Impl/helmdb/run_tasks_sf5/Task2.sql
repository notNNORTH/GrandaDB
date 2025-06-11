\timing
CREATE TEMPORARY TABLE A as
(
    Select "order".data->>'customer_id' as customer_id, review.data->>'product_id' as product_id, (review.data->>'rating')::float as rating
    From "order", review
    Where review.data->>'order_id'="order".data->>'order_id'
);

CREATE TEMPORARY TABLE mapped_customer AS (
    SELECT customer_id, row_number() OVER() -1 AS customer_id_d
    FROM (
        SELECT DISTINCT(customer_id) AS customer_id FROM A
    )
);

CREATE TEMPORARY TABLE mapped_product AS (
    SELECT product_id, row_number() OVER() -1 AS product_id_d
    FROM (
        SELECT DISTINCT(product_id) AS product_id FROM A
        
    )
);

CREATE TEMPORARY TABLE mapped_A  AS (
    SELECT customer_id_d, product_id_d, rating
    FROM A, mapped_customer, mapped_product
    WHERE A.customer_id = mapped_customer.customer_id
    AND A.product_id = mapped_product.product_id
);

SELECT rel_agg_to_array('mapped_A', 'BC', 'customer_id_d, product_id_d', 'avg(rating)');

SELECT matrix_factorization('BC','B','C');

DROP TABLE BC;
DROP TABLE B;
DROP TABLE C;
DELETE FROM mm_array;