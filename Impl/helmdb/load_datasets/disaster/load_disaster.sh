PORT=$1
gsql -d postgres  -c "CREATE DATABASE IF NOT EXISTS disaster;" -p $PORT
gsql  -d disaster  -c "CREATE EXTENSION IF NOT EXISTS postgis;" -p $PORT
gsql  -d disaster  -c "CREATE EXTENSION IF NOT EXISTS ldbc;" -p $PORT

gsql -d disaster -f ./create_table.sql -p $PORT
gsql -d disaster -f ./load_table.sql -p $PORT


gsql -d disaster -f ./create_json.sql -p $PORT
gsql -d disaster -f ./load_json.sql -p $PORT


gsql -d disaster -f ./create_graph.sql -p $PORT
gsql  -d disaster -f ./load_graph.sql -p $PORT

gsql -d disaster -f ./create_array.sql -p $PORT
gsql -d disaster -f ./load_array.sql -p $PORT
