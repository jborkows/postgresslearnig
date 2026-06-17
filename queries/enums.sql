create type ABC as enum ('A','B','C');
create table enum_example (
   abc ABC,
);

-- insert into enum_example values ('D'); -- invalid value 
insert into enum_example values ('A');

select abc, pg_column_size(abc), pg_column_size('A') from enum_example;


create type LargeEnum as enum ('Aaaaaaa','Bbbbbb','Cccccccccccccc');

with values as (
select 'Aaaaaaa' value
)
select pg_column_size(value::LargeEnum), pg_column_size(value) from values;



create type OrderingByPossitionInEnum as enum ('Large','Small','Medium', 'X-Large');


with values as (
select 'Small' value union
select 'Medium' value union
select 'Large' value union
select 'X-Large' value 
)
select * from (select value::OrderingByPossitionInEnum from "values") order by 1;
/** Prints as order in table
 Large
 Small
 Medium
 X-Large
*/

alter TYPE OrderingByPossitionInEnum add value 'VerySmall' before 'Small'; -- can add type to it

with values as (
select 'Small' value union
select 'Medium' value union
select 'Large' value union
select 'VerySmall' value union
select 'X-Large' value 
)
select * from (select value::OrderingByPossitionInEnum from "values") order by 1;
