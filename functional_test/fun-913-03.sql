/*
  1）创建图模型
  2）对顶点表的拓扑数据进行增删改查操作
  3）对边表的拓扑数据进行增删改查操作
  依次验证1-3操作之后，图模型的信息与状态
*/
SELECT *
FROM test_graph MATCH (n: v)-[r: e]->(m: v)
WHERE n.id = 6; 

delete from e where startid=6 and endid=2199023694179;
delete from v where id=2199023694179;

SELECT *
FROM test_graph MATCH (n: v)-[r: e]->(m: v)
WHERE n.id = 6; 

INSERT INTO v (id, properties) VALUES (66, '{"name":"Emma"}');
INSERT INTO e (startid, startlabelid, endid, endlabelid, properties) VALUES (6, 'v'::regclass::oid, 66, 'v'::regclass::oid, '{"weight":"2.77"}');

SELECT *
FROM test_graph MATCH (n: v)-[r: e]->(m: v)
WHERE n.id = 6;

UPDATE v SET v.id = 654965 where v.id = 654966;
UPDATE e SET e.startid = 654965 where e.startid = 654966;
UPDATE e SET e.endid = 654965 where e.endid = 654966;

SELECT *
FROM test_graph MATCH (n: v)-[r: e]->(m: v)
WHERE n.id = 6;