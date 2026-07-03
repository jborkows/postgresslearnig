# Example commands
 ```bash 

 PGPASSWORD=postgres psql -h localhost -U postgres -d postgres -c "EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT * FROM orders WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';"

 ```
