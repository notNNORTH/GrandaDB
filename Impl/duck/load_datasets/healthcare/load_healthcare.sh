agens -d postgres  -c "CREATE DATABASE IF NOT EXISTS healthcare;" -p 5678
agens -p 5678 -d healthcare -f ./create_table.sql
agens -p 5678 -d healthcare -f ./load_table.sql


agens -p 5678 -d healthcare -f ./create_json.sql
agens -p 5678 -d healthcare -f ./load_json.sql


agens -p 5678 -d healthcare -f ./create_graph.sql
agens -p 5678 -d healthcare -f ./load_graph.sql

