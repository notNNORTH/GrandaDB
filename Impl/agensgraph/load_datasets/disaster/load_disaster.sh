agens -d postgres  -c "CREATE DATABASE IF NOT EXISTS disaster;" -p 5678
gsql  -d disaster  -c "CREATE EXTENSION IF NOT EXISTS postgis;" -p 5678
agens -p 5678 -d disaster -f ./create_table.sql
agens -p 5678 -d disaster -f ./load_table.sql


agens -p 5678 -d disaster -f ./create_json.sql
agens -p 5678 -d disaster -f ./load_json.sql


agens -p 5678 -d disaster -f ./create_graph.sql
agens -p 5678 -d disaster -f ./load_graph.sql

agens -p 5678 -d disaster -f ./create_array.sql
agens -p 5678 -d disaster -f ./load_array.sql
