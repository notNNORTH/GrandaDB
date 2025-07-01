\timing
WITH 
A as (select disease_id as disease_id from diagnosis where patient_id = 99999),

B as (SELECT DISTINCT(d3.id) as disease_id from 
	disease_network 
		MATCH {(d2: disease)<-[i: is_a]-(d3: disease)}
			WHERE d2.id IN (
				SELECT d2.id FROM 
					disease_network
						MATCH {( d1 : disease)-[i: is_a]->( d2 : disease)}
					WHERE   d1.id IN (SELECT disease_id FROM A) 
					)
	),


C as (Select distinct(patient_id) as patient_id from diagnosis, B 
	WHERE diagnosis.disease_id = B.disease_id AND diagnosis.patient_id != 99999
	 and B.disease_id not in (select * from A)  
	
	) 
SELECT gender, count(gender) FROM patient, C WHERE patient.patient_id = C.patient_id GROUP BY gender;
