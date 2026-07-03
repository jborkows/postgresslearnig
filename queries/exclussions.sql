create table reservation_example (
   id bigint generated always as identity primary key,
   room_id integer,
   reservation_perion tsrange,
   exclude using gist (room_id with =, reservation_perion with &&)
);

-- ERROR:  data type integer has no default operator class for access method "gist"
-- HINT:  You must specify an operator class for the index or define a default operator class for the data type.


create extension if not exists btree_gist; --to check what it is in future, but now creation works
drop table  reservation_example;
create table reservation_example (
   id bigint generated always as identity primary key,
   room_id integer,
   reservation_perion tsrange,
   exclude using gist (room_id with =, reservation_perion with &&) WHERE (room_id < 10) --lets say that above 10 are special rooms
);

insert into reservation_example (room_id, reservation_perion) values (1,'[2023-09-01 14:00, 2023-09-09 15:00]');
insert into reservation_example (room_id, reservation_perion) values (1,'[2023-09-01 14:00, 2023-09-09 16:00]'); --error
-- ERROR:  conflicting key value violates exclusion constraint "reservation_example_room_id_reservation_perion_excl"
-- DETAIL:  Key (room_id, reservation_perion)=(1, ["2023-09-01 14:00:00","2023-09-09 16:00:00"]) conflicts with existing key (room_id, reservation_perion)=(1, ["2023-09-01 14:00:00","2023-09-09 15:00:00"]).

insert into reservation_example (room_id, reservation_perion) values (11,'[2023-09-01 14:00, 2023-09-09 15:00]');
insert into reservation_example (room_id, reservation_perion) values (11,'[2023-09-01 14:00, 2023-09-09 15:00]'); --ok 

