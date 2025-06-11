db._useDatabase("Healthcare")

if (db._collection("drug_temp") != null) db.drug_temp.drop();
if (db._collection("target_temp") != null) db.target_temp.drop();
if (db._collection("has_bond") != null) db.has_bond.drop();

db._create("drug_temp")
db._create("target_temp")
db._createEdgeCollection("has_bond")

res1 = db._query(`
For drug in Drug 
INSERT {_key:TO_STRING(drug.drug_id), drug_name:drug.drug_name} INTO drug_temp
`).getExtra();
res2 = db._query(`
Let B = (
    For drug in Drug 
    For target in drug.targets 
    RETURN DISTINCT {target_id: target.id, target_name: target.name}
) 
For b in B 
INSERT {_key: TO_STRING(b.target_id), target_name:b.target_name} INTO target_temp
`).getExtra();  
res3 = db._query(`
For drug in Drug 
For target in drug.targets 
For dt in drug_temp 
For tt in target_temp 
FILTER dt._key == TO_STRING(drug.drug_id) and tt._key == TO_STRING(target.id) 
INSERT {_from: dt._id, _to: tt._id} INTO has_bond
`).getExtra();