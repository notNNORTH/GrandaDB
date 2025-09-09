rm -f disaster.duckdb
./duck/duckdb_cli/duckdb disaster.duckdb -c "CREATE SCHEMA IF NOT EXISTS ecommerce;"

./duck/duckdb_cli/duckdb disaster.duckdb -f create_table.sql
./duck/duckdb_cli/duckdb disaster.duckdb -f load_table.sql

./duck/duckdb_cli/duckdb disaster.duckdb -f create_json.sql
./duck/duckdb_cli/duckdb disaster.duckdb -f load_json.sql

./duck/duckdb_cli/duckdb disaster.duckdb -f create_graph.sql


./duck/duckdb_cli/duckdb disaster.duckdb -f create_array.sql
./duck/duckdb_cli/duckdb disaster.duckdb -f load_array.sql
