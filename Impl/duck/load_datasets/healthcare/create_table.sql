DROP TABLE IF EXISTS Prescription;
DROP TABLE IF EXISTS Diagnosis;
DROP TABLE IF EXISTS Patient;

CREATE TABLE Patient (
    patient_id INTEGER PRIMARY KEY,
    patient_name VARCHAR(50),
    gender CHAR(1),
    date_of_birth DATE,
    date_of_death DATE
);

CREATE TABLE Diagnosis (
    patient_id INTEGER,
    disease_id BIGINT
);

CREATE TABLE Prescription (
    patient_id INTEGER,
    drug_id INTEGER,
    startdate DATE,
    enddate DATE
);
