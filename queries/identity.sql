create table id_example (
   id bigint GENERATED ALWAYS as identity primary key,
   name text
);

insert into id_example (name) values ('example');

insert into id_example (id,name) overriding system value values (2,'example'); -- this works but backed identity will not be affected
insert into id_example (name) values ('example'); -- first insert after it will fail... but it will increment mechanics and repeating it will work

