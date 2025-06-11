\c healthcare

COPY disease FROM '/tmp/m2bench/healthcare/property_graph/Disease_network_nodes_gs.csv' DELIMITER ',' CSV HEADER;
CREATE TEMP TABLE is_a_temp (
    startid BIGINT,
    endid BIGINT,
    properties JSONB
);
COPY is_a_temp (startid, endid, properties)
FROM '/tmp/m2bench/healthcare/property_graph/Disease_network_edges_gs.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

INSERT INTO is_a (startid, startlabelid, endid, endlabelid, properties)
SELECT 
    t.startid,
    'disease'::regclass::oid AS startlabelid,
    t.endid,
    'disease'::regclass::oid AS endlabelid,
    t.properties
FROM is_a_temp t;

-- used by task8
Create temporary table drug_temp as
(Select (data->>'drug_id'::TEXT)::INT as drug_id, data->>'drug_name' as drug_name From Drug);

Create temporary table target_temp as(
    Select ROW_NUMBER() OVER (ORDER BY target_id)as id, 
    jsonb_array_elements(data->'targets')->>'id' as target_id, 
    jsonb_array_elements(data->'targets')->>'name' as target_name
    From Drug
    Group by target_id, target_name
);

Create temporary table has_bonds as(
    select dt.drug_id as drug_id, tt.id as target_id 
    from (
        Select (data->>'drug_id')::INT as drug_id, jsonb_array_elements(data->'targets')->>'id' as target_id 
        From Drug
    ) dt, target_temp tt
    where dt.target_id = tt.target_id
);

create graph drug_network(drug_t VLABEL,target_t VLABEL, has_bond ELABEL);

INSERT INTO drug_t(id, properties)
    SELECT drug_id, ('{"drug_name": "' || drug_name || '"}')::jsonb
    FROM drug_temp;
CREATE INDEX ON drug_t(id);

INSERT INTO target_t(id, properties)
    SELECT id, ('{"target_name": "' || target_name || '"}')::jsonb 
    FROM target_temp;
CREATE INDEX ON target_t(id);

INSERT INTO has_bond (startid, startlabelid, endid, endlabelid, properties)
    SELECT hb.drug_id, 'drug_t'::regclass::oid, hb.target_id, 'target_t'::regclass::oid,  '{}'::jsonb 
    FROM has_bonds hb;

select load_graph('disease_network'::regclass::bigint);
select load_graph('drug_network'::regclass::bigint);