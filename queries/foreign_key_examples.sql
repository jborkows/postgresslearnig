create table states(
  id bigint generated always as identity primary key,
  name text
);

create table cities (
  id bigint generated always as identity primary key,
  name text,
  --state_id bigint REFERENCES states(id)
  state_id bigint,
  CONSTRAINT cities_state_fk foreign key (state_id) REFERENCES states(id) -- default on delete noaction, on delete restrict (similar in effect to noaction), on delete cascade   
);

SELECT
    t.relname AS table_name,
    i.relname AS index_name,
    a.attname AS column_name,
    ix.indisprimary AS is_primary,
    ix.indisunique AS is_unique,
    array_position(ix.indkey, a.attnum) AS column_order
FROM pg_class t
JOIN pg_index ix ON t.oid = ix.indrelid
JOIN pg_class i ON i.oid = ix.indexrelid
JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(ix.indkey)
WHERE t.relname = 'cities'
ORDER BY index_name, column_order; -- foreign constraint does not create index by default
