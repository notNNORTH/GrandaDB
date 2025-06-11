/*
  1）创建文档表
  2）插入文档数据
  3）查询文档数据，验证2的插入操作生效
  4）更新文档数据
  5）再次查询验证4的操作生效
  6）删除文档数据
  7）再次查询验证6的操作生效
*/

INSERT INTO Persons (id, doc) VALUES
(1, '{"name": "Alice", "age": 30, "email": "alice@example.com"}'),
(2, '{"name": "Bob", "age": 25, "email": "bob@example.com"}');

SELECT * FROM Persons;

UPDATE Persons
SET doc = jsonb_set(
                    jsonb_set(
                      doc,
                      '{age}',
                      '31',
                      true
                    ),
                    '{city}',
                    '"New York"',
                    true
                  )
WHERE id = 1;

SELECT * FROM Persons;

DELETE FROM Persons WHERE id = 2;

SELECT * FROM Persons;