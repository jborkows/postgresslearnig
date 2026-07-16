explain (analyze) with pro_users as (
   select * from users where is_pro is true
)
select * from pro_users;


explain (analyze) with pro_users as materialized (
   select * from users where is_pro is true
) 
select * from pro_users;


explain (analyze) with pro_users as not materialized (
   select * from users where is_pro is true
) 
select * from pro_users;


with recursive series as 
(
   select 1 n 
   union all
   select n+1 from series where n<10 --very important if it would be below it would still do the query
)
select * from series;

create table cte_category_example(
  id bigint generated always as identity primary key,
  name text,
  parent_id bigint REFERENCES cte_category_example(id)
);


insert into  cte_category_example (name, parent_id) values
   ('Electronics', null),
   ('Home & Garden', null),
   ('Video', 1),
   ('Audio', 1),
   ('Computers', 1),
   ('Cameras', 3),
   ('Action Cameras', 6),
   ('Microphones', 4),
   ('Headphones', 4),
   ('Laptops', 5),
   ('Desktops', 5),
   ('Furniture', 2),
   ('Plants', 2),
   ('Chairs', 12),
   ('Tables', 12),
   ('Indoor Plants', 13),
   ('Outdoor Plants', 13);

with recursive all_fun as (
   select id, name, 1 as depth, name as path from cte_category_example where parent_id is null
   union all
   select c.id, c.name, depth + 1, concat(af.path, ' -> ', c.name) from all_fun af 
   join cte_category_example c on af.id = c.parent_id
)
select * from all_fun;
