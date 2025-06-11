db._useDatabase("Healthcare")

res4 = db._query(`
LET T = (
    For p in Prescription 
    FILTER p.patient_id == 99999 
    RETURN DISTINCT {drug_id: p.drug_id}
) 
LET R = (
    For drug in drug_temp 
    For target in target_temp 
    For p in T 
    FILTER TO_STRING(p.drug_id) == drug._key 
    For v1,e1 in 1..1 Any drug has_bond 
    FILTER target._key == v1._key 
    For v2,e2 in 1..1 Any target has_bond 
    FILTER drug._key != v2._key 
    COLLECT drug1=drug.drug_name, drug2=v2.drug_name 
    aggregate common_target = LENGTH(1) 
    sort common_target desc 
    RETURN {drug1, drug2, common_target}
)
RETURN LENGTH(R)`
);

res5 = res4.getExtra();

print(res4)

print(res5['stats']['executionTime'])

// print(res1['stats']['executionTime'] + res2['stats']['executionTime'] + res3['stats']['executionTime'] + res5['stats']['executionTime'])
