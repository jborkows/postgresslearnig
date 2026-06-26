show time zone; -- current time zone e.g. Etc/UTC
set time zone 'UTC';
select '2024-01-01 12:09:12+00:00';
/**
it should work but for some reason in dadbot it don't... it will set display format for session
to make durable change:
        ALTER DATABASE your_db SET timezone = 'America/Chicago';
        -- or
        ALTER USER your_user SET timezone = 'America/Chicago';

*/
set time zone 'America/Chicago'; --

select '2024-01-01 12:09:12+00:00'::timestamptz, 
'2024-01-01 12:09:12+00:00'::timestamptz at time zone 'America/Chicago',
pg_typeof('2024-01-01 12:09:12+00:00'::timestamptz at time zone 'America/Chicago') --timestamp without time zone

;
select * from pg_timezone_names;


