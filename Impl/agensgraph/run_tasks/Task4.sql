SET graph_path = social_network;
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
		p2 -> 'person_id' AS person_idrs 
	FROM
		(
			MATCH ( p2 : person ) <-[ r : follows ]- ( p1 : person ) 
		WHERE
			p2.person_id IN ( SELECT to_jsonb ( person_id ) FROM A ) RETURN p2,
			COUNT ( p1 ) AS cnt 
		ORDER BY
			cnt DESC 
			LIMIT 10 
		) AS b 
	) SELECT COUNT
	( C.T ) AS tag_id 
FROM
	(
		MATCH ( p1 : person ) -[ r : interested_in ]-> ( T : hashtag ) 
	WHERE
		p1.person_id IN ( SELECT * FROM B ) RETURN T,
	COUNT ( * ) AS cnt 
	) AS C