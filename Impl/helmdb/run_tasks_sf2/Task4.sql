\timing
WITH A AS (
        SELECT
                person_id
        FROM
                Customer,
                (
                    SELECT TEMP
                        .customer_id AS customer_id,
                        SUM ( ( TEMP.price ) :: FLOAT ) AS total_spent
                FROM
                        Product,
                        Brand,
                        (
                        SELECT DATA
                                ->> 'customer_id' AS customer_id,
                                jsonb_array_elements ( DATA -> 'order_line' ) ->> 'product_id' AS product_id,
                                jsonb_array_elements ( DATA -> 'order_line' ) ->> 'price' AS price
                        FROM
                                "order"
                        ) AS TEMP
                WHERE
                        Brand.industry = 'Leisure'
                        AND Product.brand_id = Brand.brand_id
                        AND TEMP.product_id = Product.product_id
                GROUP BY
                        customer_id
                HAVING
                        SUM ( ( TEMP.price ) :: FLOAT ) > 10000
                ) AS atemp
        WHERE
                atemp.customer_id = Customer.customer_id
        ),
B AS (
        SELECT
                p2.id AS person_idrs, COUNT(p1) AS cnt
        FROM    social_network
        MATCH   {( p1 : person )-[ r : follows ]->( p2 : person ) } 
        WHERE   p2.id IN ( SELECT  person_id  FROM A ) 
        GROUP BY p2.id
        ORDER BY cnt DESC 
        LIMIT 10 
)
SELECT COUNT(distinct T.id) AS tag_id 
FROM    tag_network
MATCH {( p1 : person ) -[ r : interested_in ]-> ( T : tag )} 
WHERE   p1.id IN ( SELECT person_idrs FROM B )