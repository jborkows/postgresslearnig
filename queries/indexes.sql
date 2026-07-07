create table sample_for_citd (
  id bigint generated always as identity primary key,
  aaaa text
);
insert into sample_for_citd (aaaa) values ('aaa'),('bbb'),('cccc');

select *,ctid from sample_for_citd;

/*
 id | aaaa | ctid  
----+------+-------
  1 | aaa  | (0,1)    aaa is physically on page 0, position 1, ctid is pointer to table and postgres stores ctid in indexes (remember position on disk may change)
  2 | bbb  | (0,2)
  3 | cccc | (0,3)
(3 rows)
*/
-- nanoId - to generate url friendly id for browser (id bigint primary key, uiId nanoId generated)

explain select * from users where created_at = '2024-03-15';

--                                  QUERY PLAN                                  
-- -----------------------------------------------------------------------------------
--  Gather  (cost=1000.00..23605.43 rows=1 width=110)
--    Workers Planned: 2
--    ->  Parallel Seq Scan on users  (cost=0.00..22605.33 rows=1 width=110)
--          Filter: (created_at = '2024-03-15 00:00:00'::timestamp without time zone)
-- (4 rows)
create index users_created_at on users using btree(created_at);

explain select * from users where created_at = '2024-03-15';

--                                    QUERY PLAN                                    
-- ---------------------------------------------------------------------------------
--  Index Scan using users_created_at on users  (cost=0.15..8.17 rows=1 width=109)
--    Index Cond: (created_at = '2024-03-15 00:00:00'::timestamp without time zone)
-- (2 rows)
explain select * from users where created_at < '2024-03-15'; -- not using index
explain select * from users where created_at > '2024-03-15'; -- using index
explain select * from users where created_at BETWEEN '2024-03-15' and '2024-05-05'; --  using index
create index users_birth on users using btree(birth_date);

explain select * from users where birth_date = '2024-03-15';

--                                 QUERY PLAN                                 
-- ---------------------------------------------------------------------------
--  Bitmap Heap Scan on users  (cost=4.93..253.82 rows=65 width=110)
--    Recheck Cond: (birth_date = '2024-03-15'::date)
--    ->  Bitmap Index Scan on users_birth  (cost=0.00..4.91 rows=65 width=0)
--          Index Cond: (birth_date = '2024-03-15'::date)
-- (4 rows)

explain select * from users where birth_date < '2024-03-15'; -- not using index
explain select * from users where birth_date > '2024-03-15'; -- using index
explain select * from users where birth_date BETWEEN '2024-03-15' and '2024-05-05'; -- using index

select * from users;
select count(distinct is_pro)::decimal / count(*)::decimal from users; -- 0.00000...
select count(*) filter(where is_pro is true)::decimal / count(*)::decimal from users; -- 0.0396 even if column has low selectivity, access pattern makes it a good index if asking for is_pro = true users
