create table people (
   height_cm numeric,
   height_in numeric generated always as (height_cm/2.54) STORED
);
insert into people (height_cm) values (183);
select * from people;

create table example_with_columns (
   email text,
   email_domain text generated always as (split_part(email, '@', 2)) stored -- function must be deterministic, cannot generate from generated, cannot reference other rows
);
insert into example_with_columns (email) values ('xxx.xxx@wp.pl');
select * from example_with_columns;
