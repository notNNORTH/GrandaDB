./duckdb_cli/duckdb ecommerce.duckdb -c "CREATE SCHEMA IF NOT EXISTS ecommerce;"

./duckdb_cli/duckdb ecommerce.duckdb ./create_table.sql
./duckdb_cli/duckdb ecommerce.duckdb ./load_table.sql

./duckdb_cli/duckdb ecommerce.duckdb ./create_json.sql
./duckdb_cli/duckdb ecommerce.duckdb ./load_json.sql

./duckdb_cli/duckdb ecommerce.duckdb ./create_graph.sql
./duckdb_cli/duckdb ecommerce.duckdb ./load_graph.sql
