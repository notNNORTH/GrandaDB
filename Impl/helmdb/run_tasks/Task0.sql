CREATE TEMPORARY TABLE TNEW_A AS (
    SELECT distinct startid as person_id, endid as tag_id
    FROM interested_in 
);

-- Create C
CREATE TEMPORARY TABLE TNEW_C AS (
    WITH B AS (
        SELECT customer.person_id, product.brand_id, COUNT(*) as cnt
        FROM product, review, "order", customer
        WHERE customer.customer_id = "order".data->>'customer_id' AND
        "order".data->>'order_id' = review.data->>'order_id' AND
        review.data->>'product_id' = product.product_id AND
        CAST(review.data->>'rating' AS INT) = 5
        GROUP BY customer.person_id, product.brand_id)

    SELECT B.person_id, MIN(B.brand_id) AS brand_id
    FROM B, (SELECT person_id, MAX(cnt) as max_cnt FROM B GROUP BY person_id) AS T1
    WHERE B.person_id = T1.person_id AND
    B.cnt = T1.max_cnt
    GROUP BY B.person_id
);

SELECT rel_to_array('TNEW_A', 'D', 'person_id, tag_id', '1');

SELECT rel_to_array('TNEW_C', 'E', 'person_id', '(brand_Id = 50)::int');

SELECT build_logistic_regression('D', 'E', 'F');

DROP TABLE D;
DROP TABLE E;
DROP TABLE F;
DELETE FROM mm_array;