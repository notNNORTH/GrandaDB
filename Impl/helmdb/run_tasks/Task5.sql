\timing
 With A as (
	select customer.person_id::bigint as person_id
 		From "order", review, customer
 		where review.data->>'product_id' = 'B007SYGLZO' and review.data->>'order_id' =  "order".data->> 'order_id' 
 		and "order".data->>'order_date' <= '2021-06-01' and "order".data->>'order_date' >= '2020-06-01'
 		and "order".data->> 'customer_id' = customer.customer_id and customer.gender = 'F'
		)
 select count(*) from
( 	
 	select p1.id 
	from social_network MATCH {(p1: person)-[r:follows]->(p2: person)}
	where p1.id in (Select person_id from A )
) as res;
