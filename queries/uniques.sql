create table example_unique (
   id bigint generated always as identity primary key,
   value text unique
);

insert into example_unique (value) values ('a'), (null),(null); --allows null duplication
select * from example_unique;

create table more_example_unique (
   id bigint generated always as identity primary key,
   value text unique nulls not distinct
);

insert into more_example_unique (value) values ('a'), (null),(null); --fails on inserting
