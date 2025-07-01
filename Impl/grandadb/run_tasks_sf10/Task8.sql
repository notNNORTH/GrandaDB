\timing
--- skip
/*
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
    FROM has_bonds hb
*/

WITH A
AS (SELECT t.id as t_id, d2.id as drug2
    FROM drug_network
    MATCH {(d2: drug_t)-[h2: has_bond]->(t: target_t)}
    WHERE d2.id in 
        (SELECT DISTINCT(drug_id) FROM Prescription WHERE patient_id = 99999)
)

Select count(*) from (
    SELECT d1.id as drug1, A.drug2 as drug2, count(*) as common_target
    FROM  drug_network
    MATCH {(t: target_t)<-[h1: has_bond]-(d1: drug_t)},A
    WHERE t.id = A.t_id and d1.id != A.drug2
    Group By drug1, drug2
) as res
