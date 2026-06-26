create table serial_example (
   id serial -- you can use also smallserial and bigserial 
);


SELECT
   c.table_schema,
   c.table_name,
   c.column_name,
   c.data_type,
   pg_get_serial_sequence(c.table_name, c.column_name) AS sequence_name,
   c.column_default
FROM information_schema.columns c
WHERE c.column_default LIKE 'nextval%' and upper(c.table_name) = 'SERIAL_EXAMPLE';

/**
creates something like 
create sequence serial_example_id_seq as integer;
create table serial_example (
  id integer not null default nextval('serial_example_id_seq')
);
alter sequence serial_example_id_seq owner by serial_example.id -- if table deleted then index will be deleted
*/

create table combo_id_example (
   id bigint generated always as IDENTITY PRIMARy key,
   order_number serial,
   customer_name varchar(100),
   order_date date,
   total_amount numeric(10,2)
)

insert into combo_id_example (customer_name,order_date,total_amount) values ('John',CURRENT_DATE, 12.2);
select * from combo_id_example;

insert into combo_id_example (customer_name,order_date,total_amount) values ('John',CURRENT_DATE, 12.2) returning *;
insert into combo_id_example (customer_name,order_date,total_amount) values ('John',CURRENT_DATE, 12.2) returning id, order_number;

