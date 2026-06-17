select 
  pg_column_size(100::int4),
  pg_column_size(100::numeric), --8
  pg_column_size(10000::numeric),--8
  pg_column_size(10000.2::numeric);--12

