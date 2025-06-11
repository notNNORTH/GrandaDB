/*
  1）创建图模型，图模型包含多种点类型，同时给点、边添加属性，确认图模型的信息与状态
  2）修改图模型（包括点、边、属性的增删改）
  3）删除图模型
  依次验证1-3操作之后，图模型的信息与状态
*/

CREATE GRAPH test_graph(v VLABEL,e ELABEL);

select * from v;
select * from e;

INSERT INTO v (id, properties) VALUES (6, '{"name":"Jack"}');
INSERT INTO v (id, properties) VALUES (10, '{"name":"Alice"}');
INSERT INTO v (id, properties) VALUES (41, '{"name":"John"}');
INSERT INTO v (id, properties) VALUES (48, '{"name":"Mike"}');
INSERT INTO v (id, properties) VALUES (50, '{"name":"Michael"}');
INSERT INTO v (id, properties) VALUES (500020, '{"name":"Jimmy"}');
INSERT INTO v (id, properties) VALUES (654966, '{"name":"Koby"}');
INSERT INTO v (id, properties) VALUES (2199023694179, '{"name":"Tonny"}');

INSERT INTO e (startid, startlabelid, endid, endlabelid, properties) VALUES (6, 'v'::regclass::oid, 500020, 'v'::regclass::oid, '{"weight":"1"}');
INSERT INTO e (startid, startlabelid, endid, endlabelid, properties) VALUES (500020, 'v'::regclass::oid, 6, 'v'::regclass::oid, '{"weight":"1"}');
INSERT INTO e (startid, startlabelid, endid, endlabelid, properties) VALUES (6, 'v'::regclass::oid, 654966, 'v'::regclass::oid, '{"weight":"1.07113"}');
INSERT INTO e (startid, startlabelid, endid, endlabelid, properties) VALUES (654966, 'v'::regclass::oid, 6, 'v'::regclass::oid, '{"weight":"1.07113"}');
INSERT INTO e (startid, startlabelid, endid, endlabelid, properties) VALUES (6, 'v'::regclass::oid, 2199023694179, 'v'::regclass::oid, '{"weight":"1.43017"}');

select * from v;
select * from e;

drop graph test_graph;

select * from v;
select * from e;
