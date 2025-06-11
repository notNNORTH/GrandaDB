/*
  1）在TableVA上创建向量索引
  2）给定查询向量，用select语句进行top-10近邻查询
  3）用explain语句观察上述2中select语句的执行方案，采用了向量索引
  4）删除TableVA的向量索引
  5）用explain语句观察上述2中select语句的执行方案，没有向量索引
*/

explain SELECT * FROM TableVA ORDER BY vec <-> '[3,1,2]' LIMIT 10;

Drop index if exists idx_va_l2;

explain SELECT * FROM TableVA ORDER BY vec <-> '[3,1,2]' LIMIT 10;