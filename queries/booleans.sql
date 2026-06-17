create table booleans (
   value BOOLEAN
);

with candidates as(
select 't' value union all
select 'f' value union all
select 'true' value union all
select 'false' value union all
select 'y' value union all
select 'n' value union all
select '1' value union all
select '0' value union all
select 'on' value union all
select 'off' value union all
select 'yes' value union all
select 'no' value 
)
select value, value::BOOLEAN from candidates;

-- insert into booleans values (1) <-- will not work, has to be '1'
