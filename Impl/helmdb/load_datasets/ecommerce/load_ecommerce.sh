PORT=$1

gsql -d postgres -c "CREATE DATABASE IF NOT EXISTS ecommerce;" -p $PORT
gsql -d ecommerce  -c "CREATE EXTENSION IF NOT EXISTS ldbc;" -p $PORT
gsql -d ecommerce -f ./create_table.sql -p $PORT
gsql -d ecommerce -f ./load_table.sql -p $PORT


gsql -d ecommerce -f ./create_json.sql -p $PORT
gsql -d ecommerce -f ./load_json.sql -p $PORT


gsql -d ecommerce -f ./create_graph.sql -p $PORT
gsql -d ecommerce -f ./load_graph.sql -p $PORT