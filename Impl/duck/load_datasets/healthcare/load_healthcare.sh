rm -f healthcare.duckdb
./duckdb_cli/duckdb healthcare.duckdb -c "CREATE SCHEMA IF NOT EXISTS healthcare;"

./duckdb_cli/duckdb healthcare.duckdb -f create_table.sql
./duckdb_cli/duckdb healthcare.duckdb -f load_table.sql


./duckdb_cli/duckdb healthcare.duckdb -f create_json.sql
./duckdb_cli/duckdb healthcare.duckdb -f load_json.sql


./duckdb_cli/duckdb healthcare.duckdb -f create_graph.sql

