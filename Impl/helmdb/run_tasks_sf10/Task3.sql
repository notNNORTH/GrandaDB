\timing 

WITH A as (select person_id
       from Customer
       where customer_id = (select customer_id from ( select data->>'customer_id' as customer_id, sum((data->>'total_price')::Float) as order_price
                            from "order"
                            where data->>'order_date' = '2020-02-26'
                            group by customer_id
                            order by order_price DESC LIMIT 1) as cid)
),
B as (select "p1.id" as person_id from social_network
       MATCH {(p2: person)<-[r: follows]-(p1: person)} 
       WHERE "p2.id" in (
              select "p1.id" as person_id from social_network
              MATCH {(p2: person)<-[r: follows]-(p1: person)} 
              WHERE "p2.id" in (SELECT person_id from A)
       )
),

C as (  select temp.customer_id as cid,
       Product.product_id as pid,
       Product.brand_id as brand_id
       from
       (
              Select customer_id,jsonb_array_elements(data->'order_line')->>'product_id' as product_id
              from  B, Customer, "order"
              where "order".data->>'customer_id'  =Customer.customer_id
              and Customer.person_id = B.person_id
       ) as temp,
       Product
       where Product.product_id =  temp.product_id::character(11)
)
select Brand.industry, count(*) as customer_count
from C, Brand
Where C.brand_id = Brand.brand_id
group by Brand.industry;