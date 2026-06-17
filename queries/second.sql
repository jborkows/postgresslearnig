create table Foo (
id int
);

select * from Foo;

select pg_typeof(100::int8), pg_typeof(cast(100 as int8));
