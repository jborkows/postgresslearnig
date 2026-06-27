create type complex_type as (
   one text,
   second text
);

select ('one', 'aaa')::complex_type;
create table complex_type_usage (
   id bigint generated always as identity primary key,
   value complex_type
);

insert into complex_type_usage (value) values (('one','two')::complex_type);
select id, (value).one from complex_type_usage;
insert into complex_type_usage  values (DEFAULT,('one','two')::complex_type);
