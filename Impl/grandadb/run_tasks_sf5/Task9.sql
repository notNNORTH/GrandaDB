\timing

CREATE TEMPORARY TABLE drug_adverse_effect AS
(Select (data->>'drug_id')::INT AS drug_id, jsonb_array_elements(data->'adverse_effect_list')->>'adverse_effect_name' AS adverse_effect_name, 1 AS is_adverse_effect 
    From drug
    Group by drug_id, adverse_effect_name
);

CREATE TEMPORARY TABLE adverse_effect AS
(
    SELECT DISTINCT (jsonb_array_elements(data->'adverse_effect_list')->>'adverse_effect_name') AS adverse_effect_name
    FROM drug
);

CREATE TEMPORARY TABLE mapped_adverse_effect AS
(
    SELECT DISTINCT adverse_effect_name, row_number() OVER()  -1 AS adverse_effect_id
    FROM adverse_effect
);

CREATE TEMPORARY TABLE mapped_drug_adverse_effect AS
(
    SELECT dae.drug_id AS drug_id, mae.adverse_effect_id AS adverse_effect_id, dae.is_adverse_effect AS is_adverse_effect
    FROM drug_adverse_effect AS dae, mapped_adverse_effect AS mae
    WHERE dae.adverse_effect_name = mae.adverse_effect_name
);

CREATE TEMPORARY TABLE drug_for_patient9 AS 
(
    SELECT distinct(drug_id) as drug_id from Prescription where patient_id = 9
);

CREATE TEMPORARY TABLE adverse_effect_for_patient9 AS
(
    SELECT dae.drug_id, dae.adverse_effect_name, is_adverse_effect
    FROM drug_adverse_effect AS dae, drug_for_patient9 AS dfp9
    WHERE dae.drug_id = dfp9.drug_id
);

CREATE TEMPORARY TABLE mapped_drug_adverse_effect_for_patient9 AS
(
    SELECT ae9.drug_id AS drug_id, mae.adverse_effect_id AS adverse_effect_id, 
        CASE 
            WHEN is_adverse_effect IS NULL  THEN 0 
            ELSE 1 
            END  AS  is_adverse_effect 
    FROM 
        adverse_effect_for_patient9 AS ae9 
    RIGHT OUTER JOIN 
        mapped_adverse_effect mae 
        ON ae9.adverse_effect_name = mae.adverse_effect_name
);

SELECT rel_to_array('mapped_drug_adverse_effect', 'drug_effect_matrix', 'drug_id,adverse_effect_id', 'is_adverse_effect');

SELECT rel_to_array('mapped_drug_adverse_effect_for_patient9', 'drug_effect_matrix_9', 'drug_id,adverse_effect_id', 'is_adverse_effect');

SELECT cosine_similarity('drug_effect_matrix_9','drug_effect_matrix', 'similarity_matrix');

SELECT count(*) FROM (SELECT UNNEST(similarity) AS i FROM similarity_matrix) where i != 0;

DROP TABLE drug_effect_matrix;
DROP TABLE drug_effect_matrix_9;
DROP TABLE similarity_matrix;
DELETE FROM mm_array;