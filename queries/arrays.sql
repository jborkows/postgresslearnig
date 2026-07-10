create table array_example (
   id bigint generated always as IDENTITY PRIMARY key,
   int_array integer[],
   texT_array text[],
   bool_array boolean[],
   nested integer[][]
);

insert into array_example (int_array, texT_array, bool_array)
values(
   ARRAY [1,2,3],
   ARRAY ['aa'],
   ARRAY [true, false]  
);
insert into array_example (nested) values ('{ {1,2,3}, {3,4,5} }'); --alternative syntax
select * from array_example;

select int_array[0], int_array[1], int_array[1:3], int_array[2:] from array_example; -- arrays are 1 based indexed!, 2: till end, 1:3 from 1 to 3 including 3

insert into array_example (texT_array) values ('{orange,red}');
insert into array_example (texT_array) values ('{green,yellow, orange}'), ('{yellow}');
select texT_array from array_example
where text_array @> '{red}';
select texT_array from array_example 
where text_array @> '{yellow}'; --match all containing all elements from array
select texT_array from array_example 
where text_array @> '{yellow, x}'; --no results


with colors as (
   select id, unnest(text_array) as color 
   from  array_example
   where text_array @> '{yellow}' or text_array @> '{red}'
)
select * from colors; --it will produce multiple rows from array

select ORDINALITY, element from unnest(ARRAY['first', 'second']) with ORDINALITY as t(element, ORDINALITY);

--  ordinality | element 
-- ------------+---------
--           1 | first
--           2 | second
-- (2 rows)
select id, element from unnest(ARRAY['first', 'second']) with ORDINALITY as t(element, id); --also works


select string_to_table('apple,banana,orange',',');
