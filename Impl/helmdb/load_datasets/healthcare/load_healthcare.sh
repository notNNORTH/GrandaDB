PORT=$1
gsql -d postgres  -c "CREATE DATABASE IF NOT EXISTS healthcare;" -p $PORT
gsql -d healthcare  -c "CREATE EXTENSION IF NOT EXISTS ldbc;" -p $PORT
gsql -d healthcare -f ./create_table.sql -p $PORT
gsql -d  healthcare -f ./load_table.sql -p $PORT


gsql  -d  healthcare -f ./create_json.sql -p $PORT
gsql  -d  healthcare -f ./load_json.sql -p $PORT


gsql  -d  healthcare -f ./create_graph.sql -p $PORT
gsql  -d  healthcare -f ./load_graph.sql -p $PORT