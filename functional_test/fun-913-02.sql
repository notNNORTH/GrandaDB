/*
  1）给图中的点边添加整型、浮点型、字符串类型、布尔型、日期型的属性
  2）对上述类型的数据进行修改
  3）对上述类型的数据进行删除 
  依次验证
*/
CREATE GRAPH test_graph(v VLABEL,e ELABEL);

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

-- 对点进行修改
select * from v;
UPDATE v
SET properties = jsonb_set(properties, '{int_val}', '42', true)
WHERE id = 6;

SELECT * FROM v WHERE id = 6;

UPDATE v
SET properties = jsonb_set(properties, '{float_val}', '3.14', true)
WHERE id = 6;

SELECT * FROM v WHERE id = 6;

UPDATE v
SET properties = jsonb_set(properties, '{str_val}', '"hello world"', true)
WHERE id = 6;

SELECT * FROM v WHERE id = 6;

UPDATE v
SET properties = jsonb_set(properties, '{bool_val}', 'true', true)
WHERE id = 6;

SELECT * FROM v WHERE id = 6;

UPDATE v
SET properties = jsonb_set(properties, '{date_val}', '"2025-04-13"', true)
WHERE id = 6;

SELECT * FROM v WHERE id = 6;

-- 对点属性进行删除
select * from v;
UPDATE v
SET properties = properties - 'int_val'
WHERE id = 6;

SELECT * FROM v WHERE id = 6;

UPDATE v
SET properties = properties - 'float_val'
WHERE id = 6;

SELECT * FROM v WHERE id = 6;

UPDATE v
SET properties = properties - 'str_val'
WHERE id = 6;

SELECT * FROM v WHERE id = 6;

UPDATE v
SET properties = properties - 'bool_val'
WHERE id = 6;

SELECT * FROM v WHERE id = 6;

UPDATE v
SET properties = properties - 'date_val'
WHERE id = 6;

SELECT * FROM v WHERE id = 6;

-- 对边进行修改
select * from e;
UPDATE e
SET properties = jsonb_set(properties, '{int_val}', '42', true)
WHERE startid = 6 and endid = 500020;

SELECT * FROM e WHERE startid = 6 and endid = 500020;

UPDATE e
SET properties = jsonb_set(properties, '{float_val}', '3.14', true)
WHERE startid = 6 and endid = 500020;

SELECT * FROM e WHERE startid = 6 and endid = 500020;

UPDATE e
SET properties = jsonb_set(properties, '{str_val}', '"hello world"', true)
WHERE startid = 6 and endid = 500020;

SELECT * FROM e WHERE startid = 6 and endid = 500020;

UPDATE e
SET properties = jsonb_set(properties, '{bool_val}', 'true', true)
WHERE startid = 6 and endid = 500020;

SELECT * FROM e WHERE startid = 6 and endid = 500020;

UPDATE e
SET properties = jsonb_set(properties, '{date_val}', '"2025-04-13"', true)
WHERE startid = 6 and endid = 500020;

SELECT * FROM e WHERE startid = 6 and endid = 500020;

-- 对边属性进行删除
select * from e;
UPDATE e
SET properties = properties - 'int_val'
WHERE startid = 6 and endid = 500020;

SELECT * FROM e WHERE startid = 6 and endid = 500020;

UPDATE e
SET properties = properties - 'float_val'
WHERE startid = 6 and endid = 500020;

SELECT * FROM e WHERE startid = 6 and endid = 500020;

UPDATE e
SET properties = properties - 'str_val'
WHERE startid = 6 and endid = 500020;

SELECT * FROM e WHERE startid = 6 and endid = 500020;

UPDATE e
SET properties = properties - 'bool_val'
WHERE startid = 6 and endid = 500020;

SELECT * FROM e WHERE startid = 6 and endid = 500020;

UPDATE e
SET properties = properties - 'date_val'
WHERE startid = 6 and endid = 500020;

SELECT * FROM e WHERE startid = 6 and endid = 500020;