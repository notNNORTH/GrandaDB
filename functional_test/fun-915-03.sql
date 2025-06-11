/*
  1）doc列支持BTREE索引、GIN索引、哈希索引、表达式索引、部分索引、复合索引以及全文索引
  2）对每种索引，在创建索引前执行相应的查询，记录时间
  3）创建相应的索引，记录创建索引的耗时
  4）再次执行步骤 2 中的查询，记录查询时间
  5）对比步骤 2和步骤4的耗时，检查索引是否生效
  6）对索引执行查询和删除操作
*/
INSERT INTO Persons (id, doc)
SELECT
  i,
  json_build_object(
    'name', 'User' || i,
    'age', (20 + i % 30),
    'email', 'user' || i || '@example.com',
    'bio', repeat('hello world ', 10)
  )::jsonb
FROM generate_series(2, 10000) AS i;

\timing
/**
 * btree表达式索引
 */
-- 查询时间（无索引)
EXPLAIN ANALYZE
SELECT * FROM Persons WHERE doc ->> 'age' = '30';
-- 创建索引
CREATE INDEX idx_btree_age ON Persons ((doc ->> 'age'));
-- 查询时间（有索引)
EXPLAIN ANALYZE
SELECT * FROM Persons WHERE doc ->> 'age' = '30';

/**
 * gin索引
 */
-- 查询时间（无索引)
EXPLAIN ANALYZE
SELECT * FROM Persons WHERE doc ? 'email';
-- 创建索引
CREATE INDEX idx_gin_json ON Persons USING GIN (doc);
-- 查询时间（有索引)
EXPLAIN ANALYZE
SELECT * FROM Persons WHERE doc ? 'email';

/**
 * hash索引
 */
-- 查询时间（无索引)
EXPLAIN ANALYZE
SELECT * FROM Persons WHERE doc ->> 'email' = 'user100@example.com';
-- 创建索引
CREATE INDEX idx_hash_email ON Persons USING HASH ((doc ->> 'email'));
-- 查询时间（有索引)
EXPLAIN ANALYZE
SELECT * FROM Persons WHERE doc ->> 'email' = 'user100@example.com';

/**
 * 部分索引 + lowercase + LIKE 查询
 */
drop index idx_btree_age;
-- 查询时间（无索引)
EXPLAIN ANALYZE
SELECT * FROM Persons WHERE doc ->> 'age' = '30';
-- 创建索引
CREATE INDEX idx_partial_age30 ON Persons ((doc ->> 'age')) WHERE (doc ->> 'age') = '30';
-- 查询时间（有索引)
EXPLAIN ANALYZE
SELECT * FROM Persons WHERE doc ->> 'age' = '30';

/**
 * 复合索引
 */
-- 查询时间（无索引)
EXPLAIN ANALYZE
SELECT * FROM Persons
WHERE doc ->> 'name' = 'User30' AND doc ->> 'age' = '50';
-- 创建索引
CREATE INDEX idx_compound_name_age ON Persons (
  (doc ->> 'name'),
  (doc ->> 'age')
);
-- 查询时间（有索引)
EXPLAIN ANALYZE
SELECT * FROM Persons
WHERE doc ->> 'name' = 'User30' AND doc ->> 'age' = '50';

/**
 * 全文索引
 */
-- 查询时间（无索引)
EXPLAIN ANALYZE
SELECT * FROM Persons
WHERE to_tsvector('english', doc ->> 'bio') @@ to_tsquery('hello');
-- 创建索引
CREATE INDEX idx_tsv_bio ON Persons
USING GIN (to_tsvector('english', doc ->> 'bio'));
-- 查询时间（有索引)
EXPLAIN ANALYZE
SELECT * FROM Persons
WHERE to_tsvector('english', doc ->> 'bio') @@ to_tsquery('hello');