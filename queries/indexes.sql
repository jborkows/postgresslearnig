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
create index users_created_at on users using btree(created_at); -- can use shortcut on users(created_at)

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


select * from users limit 1;
create index users_multi_index on users using btree(first_name, last_name, birth_date);
explain select first_name from users where first_name='AAA';
--                                      QUERY PLAN                                     
-- ------------------------------------------------------------------------------------
--  Index Only Scan using users_multi_index on users  (cost=0.42..8.44 rows=1 width=5)
--    Index Cond: (first_name = 'AAA'::text)
-- (2 rows)
explain select * from users where first_name='AAA';
--                                    QUERY PLAN                                    
-- ---------------------------------------------------------------------------------
--  Index Scan using users_multi_index on users  (cost=0.42..8.44 rows=1 width=123)
--    Index Cond: ((first_name)::text = 'AAA'::text)
-- (2 rows)
explain select * from users where last_name='AAA'; -- a bit surprising, index is used but is expensive comparing to only first_name
--                                     QUERY PLAN                                    
-- ----------------------------------------------------------------------------------
--  Index Scan using users_multi_index on users  (cost=0.42..52.77 rows=1 width=123)
--    Index Cond: ((last_name)::text = 'AAA'::text)
-- (2 rows)

explain select * from users where last_name='Smith'; -- using more real data
--                                       QUERY PLAN                                       
-- ---------------------------------------------------------------------------------------
--  Bitmap Heap Scan on users  (cost=1248.97..40326.59 rows=55267 width=123)
--    Recheck Cond: ((last_name)::text = 'Smith'::text)
--    ->  Bitmap Index Scan on users_multi_index  (cost=0.00..1235.15 rows=55267 width=0)
--          Index Cond: ((last_name)::text = 'Smith'::text)
-- (4 rows)

explain select * from users where last_name = 'BBB' and first_name='AAA'; -- order of arguments does not matter if they are mentioned
--                                         QUERY PLAN                                        
-- ------------------------------------------------------------------------------------------
--  Index Scan using users_multi_index on users  (cost=0.42..8.45 rows=1 width=123)
--    Index Cond: (((first_name)::text = 'AAA'::text) AND ((last_name)::text = 'BBB'::text))
-- (2 rows)

explain select * from users where birth_date = '1989-09-04' and first_name='AAA'; -- same almost as in looking for last_name only
--                                         QUERY PLAN                                        
-- ------------------------------------------------------------------------------------------
--  Index Scan using users_multi_index on users  (cost=0.42..52.79 rows=1 width=123)
--    Index Cond: (((first_name)::text = 'AAA'::text) AND (birth_date = '1989-09-04'::date))
-- (2 rows)

-- left to right, no skipping, stop at first range - rules to avoid too much scanning, as rule try to keep first column of index for strict equality

drop index users_multi_index ;
create index users_first_name on users using btree(first_name);
create index users_last_name on users using btree(last_name);
explain select * from users where last_name = 'Smith' and first_name='John';  -- better than no index, searches both index and combine them if using or instead of and there would be BitmapOr
--                                           QUERY PLAN                                           
-- -----------------------------------------------------------------------------------------------
--  Bitmap Heap Scan on users  (cost=1192.58..10200.23 rows=2944 width=123)
--    Recheck Cond: (((first_name)::text = 'John'::text) AND ((last_name)::text = 'Smith'::text))
--    ->  BitmapAnd  (cost=1192.58..1192.58 rows=2944 width=0)
--          ->  Bitmap Index Scan on users_first_name  (cost=0.00..583.93 rows=53267 width=0)
--                Index Cond: ((first_name)::text = 'John'::text)
--          ->  Bitmap Index Scan on users_last_name  (cost=0.00..606.93 rows=55267 width=0)
--                Index Cond: ((last_name)::text = 'Smith'::text)
-- (7 rows)

create index users_multi_index on users using btree(first_name, last_name, birth_date) INCLUDE (id, is_pro);

explain select last_name, first_name from users where last_name = 'Smith' and first_name='John';  
--                                         QUERY PLAN                                        
-- ------------------------------------------------------------------------------------------
--  Index Only Scan using users_multi_index on users  (cost=0.42..139.31 rows=2944 width=12)
--    Index Cond: ((first_name = 'John'::text) AND (last_name = 'Smith'::text))
-- (2 rows)
explain select last_name, first_name, is_pro from users where last_name = 'Smith' and first_name='John';  -- is_pro and id is part of index stored value but not indexes itself
--                                         QUERY PLAN                                        
-- ------------------------------------------------------------------------------------------
--  Index Only Scan using users_multi_index on users  (cost=0.42..139.31 rows=2944 width=13)
--    Index Cond: ((first_name = 'John'::text) AND (last_name = 'Smith'::text))
-- (2 rows)
-- Covering indexes can be not used if table data are changing frequent
create index user_email on users(email) where is_pro=true; -- partial index
explain select * from users where email='user1@example.com'; -- no index
--                                 QUERY PLAN                                
-- --------------------------------------------------------------------------
--  Gather  (cost=1000.00..42856.43 rows=1 width=123)
--    Workers Planned: 2
--    ->  Parallel Seq Scan on users  (cost=0.00..41856.33 rows=1 width=123)
--          Filter: ((email)::text = 'user1@example.com'::text)
-- (4 rows)

explain select * from users where email='user1@example.com' and is_pro=true; -- partial index used
--
--                                 QUERY PLAN                                
-- --------------------------------------------------------------------------
--  Index Scan using user_email on users  (cost=0.41..8.43 rows=1 width=123)
--    Index Cond: ((email)::text = 'user1@example.com'::text)
-- (2 rows)
--
create index users_dates on users(birth_date, created_at);
explain select * from users  order by birth_date, created_at limit 10;
--                                          QUERY PLAN                                         
-- --------------------------------------------------------------------------------------------
--  Limit  (cost=0.42..2.20 rows=10 width=123)
--    ->  Index Scan using users_dates on users  (cost=0.42..177003.57 rows=1000000 width=123)
-- (2 rows)
explain select * from users  order by birth_date desc, created_at desc limit 10; --index still used
--
--                                              QUERY PLAN                                              
-- -----------------------------------------------------------------------------------------------------
--  Limit  (cost=0.42..2.20 rows=10 width=123)
--    ->  Index Scan Backward using users_dates on users  (cost=0.42..177003.57 rows=1000000 width=123)
-- (2 rows)

explain select * from users  order by birth_date desc, created_at asc limit 10; --index used but not such efficient

--                                                 QUERY PLAN                                                 
-- -----------------------------------------------------------------------------------------------------------
--  Limit  (cost=12.82..14.85 rows=10 width=123)
--    ->  Incremental Sort  (cost=12.82..202835.06 rows=1000000 width=123)
--          Sort Key: birth_date DESC, created_at
--          Presorted Key: birth_date
--          ->  Index Scan Backward using users_birth on users  (cost=0.42..168418.90 rows=1000000 width=123)
-- (5 rows)

drop index users_dates ;
create index users_dates on users(birth_date desc, created_at asc);
explain select * from users  order by birth_date desc, created_at asc limit 10; --now again index is used fully

--                                          QUERY PLAN                                         
-- --------------------------------------------------------------------------------------------
--  Limit  (cost=0.42..2.20 rows=10 width=123)
--    ->  Index Scan using users_dates on users  (cost=0.42..177003.57 rows=1000000 width=123)
-- (2 rows)
explain select * from users  order by birth_date asc, created_at desc limit 10; --now again index is used fully using scan backward


drop index users_dates ;
create index users_dates on users(birth_date desc nulls last, created_at asc nulls first); -- in desc nulls by default are first, in asc are last, having this nulls go to top
explain select * from users  order by birth_date desc, created_at asc limit 10; 
--                                                 QUERY PLAN                                                 
-- -----------------------------------------------------------------------------------------------------------
--  Limit  (cost=12.82..14.85 rows=10 width=123)
--    ->  Incremental Sort  (cost=12.82..202835.06 rows=1000000 width=123)
--          Sort Key: birth_date DESC, created_at
--          Presorted Key: birth_date
--          ->  Index Scan Backward using users_birth on users  (cost=0.42..168418.90 rows=1000000 width=123)
-- (5 rows)

explain select * from users  order by birth_date desc nulls last, created_at asc nulls first limit 10; 
--                                          QUERY PLAN                                         
-- --------------------------------------------------------------------------------------------
--  Limit  (cost=0.42..2.20 rows=10 width=123)
--    ->  Index Scan using users_dates on users  (cost=0.42..177003.57 rows=1000000 width=123)
-- (2 rows)

create index users_functional_index on users((split_part(email, '@', 2)));
explain select * from users where  split_part(email, '@', 2) = 'beer.com';

--                                        QUERY PLAN                                        
-- -----------------------------------------------------------------------------------------
--  Bitmap Heap Scan on users  (cost=59.17..13839.33 rows=5000 width=123)
--    Recheck Cond: (split_part((email)::text, '@'::text, 2) = 'beer.com'::text)
--    ->  Bitmap Index Scan on users_functional_index  (cost=0.00..57.92 rows=5000 width=0)
--          Index Cond: (split_part((email)::text, '@'::text, 2) = 'beer.com'::text)
-- (4 rows)

drop index users_functional_index;
create index user_email_lower on users((lower(email)));
explain select * from users where lower(email) = lower('user1@example.com'); --index used
explain select * from users where lower(email) like 'user1%'; --index not used
drop index user_email_lower;
create index users_email_btree on users using btree(email);
create index users_email_hash on users using hash(email); -- postgres keeps hash values is kept as hash so only strict equality

explain select * from users where email = 'user1@example.com'; --hash index used it is faster for equality
explain select * from users where email like 'user1@example%'; --no index was used

