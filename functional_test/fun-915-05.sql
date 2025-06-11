/*
  1）执行包含todoc的查询语句
  2）验证查询结果是否输出为json文档
*/
delete from person;

insert into DOCUMENTS person(id,name,friends_id,doc) values (1,ROW('aa','bb'),ARRAY[2,3,4],{detail:{email:'e1@xx.com',phone_number:'p1'},birth:'2000-1-1'}::jsonb),
(2,ROW('cc','dd'),ARRAY[1,3,4],{detail:{email:'e2@xx.com',phone_number:'p2'},birth:'2001-3-1'}::jsonb);
insert into DOCUMENTS person(id,name,friends_id,doc) values (3,ROW('ee','ff'),ARRAY[1,2],{detail:{email:'e3@xx.com',phone_number:'p3'},birth:'2006-1-1'}::jsonb),
(4,ROW('gg','hh'),ARRAY[1,2],{detail:{email:'e4@xx.com',phone_number:'p4'},birth:'2001-8-1'}::jsonb);

SELECT person.id ,(SELECT TODOC fid, friends.doc.detail.email::varchar AS femail 
                        FROM unnest(person.friends_id) AS fid JOIN person AS friends ON fid = friends.id) AS friends 
    FROM person;