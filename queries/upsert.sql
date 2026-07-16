create table kv (
  key text primary key,
  value text
);

insert into kv values ('a','b');
insert into kv values ('a','c') on conflict (key) do nothing; --stays b
insert into kv values ('a','d') on conflict (key) do update set value=excluded.value; --converted to d

insert into kv values ('a','e') on conflict (key) do update set value=excluded.value where kv.value is null; --will stay d
update kv set value = null;
insert into kv values ('a','e') on conflict (key) do update set value=excluded.value where kv.value is null; --converted to e

insert into kv values ('a','e') on conflict (key) do update set value=excluded.value where kv.value is null returning *; -- 0 rows
update kv set value = null;
insert into kv values ('a','e') on conflict (key) do update set value=excluded.value where kv.value is null returning *; -- 1 rows
