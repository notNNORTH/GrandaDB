./duckdb_cli/duckdb ecommerce.duckdb -c "CREATE SCHEMA IF NOT EXISTS ecommerce;"

./duckdb_cli/duckdb ecommerce.duckdb -f create_table.sql
./duckdb_cli/duckdb ecommerce.duckdb -f load_table.sql

./duckdb_cli/duckdb ecommerce.duckdb -f create_json.sql
./duckdb_cli/duckdb ecommerce.duckdb -f load_json.sql

./duckdb_cli/duckdb ecommerce.duckdb -f create_graph.sql

