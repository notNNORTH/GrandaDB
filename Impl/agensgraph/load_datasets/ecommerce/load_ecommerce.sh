agens -d postgres  -c "CREATE DATABASE IF NOT EXISTS ecommerce;" -p 5678
agens -p 5678 -d ecommerce -f ./create_table.sql
agens -p 5678 -d ecommerce -f ./load_table.sql


agens -p 5678 -d ecommerce -f ./create_json.sql
agens -p 5678 -d ecommerce -f ./load_json.sql


agens -p 5678 -d ecommerce -f ./create_graph.sql
agens -p 5678 -d ecommerce -f ./load_graph.sql
