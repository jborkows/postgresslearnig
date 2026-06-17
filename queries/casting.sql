select pg_typeof(100::int8), pg_typeof(cast(100 as int8));
select integer '100'; --literal integer
-- select integer 100; -- error

