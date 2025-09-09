COPY Patient FROM '/tmp/m2bench/healthcare/table/Patient.csv' 
    (FORMAT CSV, HEADER, DELIMITER ',');

COPY Prescription FROM '/tmp/m2bench/healthcare/table/Prescription.csv' 
    (FORMAT CSV, HEADER, DELIMITER ',');

COPY Diagnosis FROM '/tmp/m2bench/healthcare/table/Diagnosis.csv' 
    (FORMAT CSV, HEADER, DELIMITER ',');

CREATE INDEX diagnosis_pi_idx ON Diagnosis(patient_id);
-- CREATE INDEX diagnosis_di_idx ON Diagnosis(disease_id);     -- duckdb will encounter an error when executing this line
CREATE INDEX prescription_pi_idx ON Prescription(patient_id);