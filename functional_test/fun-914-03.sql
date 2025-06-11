/*
  1）在TableVA中，用insert语句插入2条包含向量的记录
  2）用select语句可以查询到TableVA中包含向量的2条记录
  3）用delete语句删除TableVA中第一条包含向量的记录，并用select语句显示TableVA中剩余的记录
  4）用update语句修改TableVA中记录的向量，并用select语句显示修改后的记录
*/

INSERT INTO TableVA (id, vec) VALUES
(1, '[1.0, 2.0, 3.0]'),
(2, '[4.0, 5.0, 6.0]');
SELECT * FROM TableVA;

DELETE FROM TableVA WHERE id = 1;

SELECT * FROM TableVA;

UPDATE TableVA
SET vec = '[7.7, 8.8, 9.9]'
WHERE id = 2;

SELECT * FROM TableVA;
