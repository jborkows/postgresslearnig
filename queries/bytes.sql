select pg_typeof(md5('Hello world'));--text
select pg_typeof(decode(md5('Hello world'),'hex'));--bytea
select pg_typeof(sha256('Hello world'));--bytea


with options as (
select pg_column_size(md5('Hello world')) value, 'md5' data_type  union
select pg_column_size(decode(md5('Hello world'),'hex')), 'md5 decoded' union
select pg_column_size(md5('Hello world') :: uuid), 'md5 uuid' union
select pg_column_size(sha256('Hello world')), 'sha256' 
)
select * from "options" order by data_type;
/**
36
20
16 <- uuid smallest representation
36
*/
