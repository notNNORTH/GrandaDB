/*
  1）执行路径表达式查询语句
  2）执行解嵌套查询语句
  3）验证1和2的结果是否符合预期
*/
CREATE TYPE NameType AS (first_name VARCHAR(50),last_name VARCHAR(50));

CREATE DOCUMENTS Person(
	name NameType,
	friends_id int[]
);
insert into DOCUMENTS person(id,name,friends_id,doc) values (1,ROW('aa','bb'),ARRAY[2,3,4],{detail:{email:'e1@xx.com',phone_number:'p1'},birth:'2000-1-1'}::jsonb),
(2,ROW('cc','dd'),ARRAY[1,3,4],{detail:{email:'e2@xx.com',phone_number:'p2'},birth:'2001-3-1'}::jsonb);

--以下二者等价
SELECT person.name.first_name from person; 
SELECT name.first_name from person; 

-- 以下三者等价
SELECT detail.email from person;
SELECT doc.detail.email from person;
SELECT person.doc.detail.email from person;
/**
* 解嵌套查询语句
*/
create documents mydoc;
insert into documents mydoc values (1,{vv:[[{k: 1},{k: 2}],[{k: 3},{k: 4}]]}::jsonb),(2,{vv:[[{k: 5},{k: 6}],[{k: 7},{k: 8}]]}::jsonb);
select mydoc.id,v1,v2.k from mydoc UNWIND json_array_elements((mydoc.vv)::json) as v1 UNWIND json_array_elements((v1)::json) as v2;