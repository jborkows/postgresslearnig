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

alter TYPE OrderingByPossitionInEnum add value 'VerySmall' before 'Small'; -- can add type to it, there is also after

with values as (
select 'Small' value union
select 'Medium' value union
select 'Large' value union
select 'VerySmall' value union
select 'X-Large' value 
)
select * from (select value::OrderingByPossitionInEnum from "values") order by 1;

create type EnumExampleOne as enum ('A', 'B', 'C');

create table UsingExampleOne (
   value EnumExampleOne
);

insert into UsingExampleOne values ('A');
insert into UsingExampleOne values ('B');
insert into UsingExampleOne values ('C');

create type SmallerEnum as enum ('A', 'B');

begin
   update UsingExampleOne
   set value = 'B'
   where value = 'C';

   alter table UsingExampleOne 
   alter column value type SmallerEnum 
   using value::text::SmallerEnum;
end;

select * from pg_catalog.pg_enum;
select enum_range(null, 'C'::EnumExampleOne); -- show all till 'C'
select enum_range('B'::EnumExampleOne, 'C'::EnumExampleOne); -- show all from B to C

  SELECT
      e.enumlabel AS value,
      e.enumsortorder AS sort_key,
      ROW_NUMBER() OVER (ORDER BY e.enumsortorder) AS position
  FROM pg_catalog.pg_enum e
  JOIN pg_catalog.pg_type t ON t.oid = e.enumtypid
  WHERE lower(t.typname) = 'enumexampleone'
  ORDER BY e.enumsortorder;

