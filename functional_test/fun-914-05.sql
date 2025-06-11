/*
  采用内积距离、欧式距离、余弦距离重复fun-914-04的向量检索的测试
*/

CREATE INDEX ON TableVA USING hnsw (vec vector_ip_ops);

CREATE INDEX ON TableVA USING hnsw (vec vector_cosine_ops);

-- 内积距离
-- 精确查询
SET enable_indexscan = off;
SELECT id, vec
FROM TableVA
ORDER BY vec <#> '[1.0, 2.0, 3.0]'
LIMIT 10;

-- 启用索引查询
SET enable_indexscan = on;
SELECT id, vec
FROM TableVA
ORDER BY vec <#> '[1.0, 2.0, 3.0]'
LIMIT 10;
-- 余弦距离
-- 精确查询
SET enable_indexscan = off;
SELECT id, vec
FROM TableVA
ORDER BY vec <=> '[1.0, 2.0, 3.0]'
LIMIT 10;

-- 启用索引查询
SET enable_indexscan = on;
SELECT id, vec
FROM TableVA
ORDER BY vec <=> '[1.0, 2.0, 3.0]'
LIMIT 10;
