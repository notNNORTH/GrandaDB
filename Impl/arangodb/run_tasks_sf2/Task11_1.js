if (db._collection("T11_temp") != null) db.T11_temp.drop();
if (db._collection("Site_roadnode") != null) db.Site_roadnode.drop();

db._create("T11_temp")
db._create("Site_roadnode")

