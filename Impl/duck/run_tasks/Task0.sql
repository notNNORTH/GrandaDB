LOAD duckpgq;

CREATE TEMP TABLE TNEW_D (person_id INTEGER, tag_id INTEGER, val DOUBLE);
CREATE INDEX TNEW_D_person_tag_idx ON TNEW_D(person_id, tag_id);
CREATE INDEX TNEW_D_tag_idx ON TNEW_D(tag_id);
CREATE INDEX TNEW_D_person_idx ON TNEW_D(person_id);

CREATE TEMP TABLE TNEW_E (person_id INTEGER, val DOUBLE);
CREATE INDEX TNEW_E_person_idx ON TNEW_E(person_id);

DROP TABLE IF EXISTS TEMP_w;
CREATE TABLE TEMP_w (i INTEGER, val DOUBLE);
CREATE INDEX TEMP_w_i_idx ON TEMP_w(i);

CREATE TEMP TABLE TEMP_w_new (i INTEGER, val DOUBLE);

-- Fill TEMP_w
INSERT INTO TEMP_w
SELECT i, 1.0 AS val
FROM range(0, 300) tbl(i);

-- Create A
CREATE TEMP TABLE TNEW_A AS
SELECT CAST(person_id AS INTEGER) AS person_id,
       CAST(tag_id AS INTEGER) AS tag_id
FROM GRAPH_TABLE(social_network
    MATCH (p:Person)-[i:Interested_in]->(t:Hashtag)
    COLUMNS (p.person_id AS person_id, t.tag_id AS tag_id)
)
GROUP BY person_id, tag_id;

-- Create C
CREATE TEMP TABLE TNEW_C AS(
    WITH B AS (
        SELECT c.person_id, p.brand_id, COUNT(*) as cnt
        FROM product p
        JOIN review r ON p.product_id = json_extract_string(r.json, '$.product_id')
        JOIN "order" o ON json_extract_string(o.json, '$.order_id') = json_extract_string(r.json, '$.order_id')
        JOIN customer c ON c.customer_id = json_extract_string(o.json, '$.customer_id')
        WHERE CAST(json_extract_string(r.json, '$.rating') AS INT) = 5
        GROUP BY c.person_id, p.brand_id
    )
    SELECT B.person_id, MIN(B.brand_id) AS brand_id
    FROM B
    JOIN (
        SELECT person_id, MAX(cnt) AS max_cnt
        FROM B
        GROUP BY person_id
    ) AS T1
    ON B.person_id = T1.person_id
    AND B.cnt = T1.max_cnt
    GROUP BY B.person_id
);

-- Create D
INSERT INTO TNEW_D
SELECT d.person_id,
       d.tag_id,
       CASE WHEN a.person_id IS NULL THEN 0 ELSE 1 END AS val
FROM (
    SELECT (i / 300) AS person_id, (i % 300) AS tag_id
    FROM range(0, 2984700) tbl(i)
) d
LEFT JOIN TNEW_A a
ON a.person_id = d.person_id AND a.tag_id = d.tag_id;

-- Create E
INSERT INTO TNEW_E
SELECT d.i AS person_id,
       CASE 
           WHEN c.person_id IS NULL THEN 0
           WHEN c.brand_id = 50 THEN 1
           ELSE 0 
       END AS val
FROM range(0, 9949) AS d(i)
LEFT JOIN TNEW_C c
ON c.person_id = d.i;

-- iteration
CREATE TEMP TABLE Xw AS
SELECT d.person_id,
       SUM(d.val * w.val) AS val
FROM TNEW_D d
JOIN TEMP_w w ON d.tag_id = w.i
GROUP BY d.person_id;

INSERT INTO TEMP_w_new
SELECT w.i,
       (w.val - o.val) AS val
FROM (
    SELECT d.tag_id AS i,
           0.0001 * SUM(diff.val * d.val) AS val
    FROM (
        SELECT x.person_id,
               (1.0 / (1 + exp(-1 * x.val))) - e.val AS val
        FROM Xw x
        JOIN TNEW_E e ON x.person_id = e.person_id
    ) diff
    JOIN TNEW_D d ON d.person_id = diff.person_id
    GROUP BY d.tag_id
) o
JOIN TEMP_w w ON o.i = w.i;

DELETE FROM TEMP_w;

INSERT INTO TEMP_w
SELECT i, val FROM TEMP_w_new;

DELETE FROM TEMP_w_new;
