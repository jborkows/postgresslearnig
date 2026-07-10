create table natural_join_a (
  id bigint generated always as identity primary key,
  some_common int
);
create table natural_join_b (
  b_id bigint generated always as identity primary key,
  some_common int,
  fun text
);
insert into natural_join_a (some_common) values (1),(2),(3);
insert into natural_join_b (some_common,fun) values (1,'a'),(2,'b'),(3,'c');

select * from natural_join_a join natural_join_b using (some_common);
--  some_common | id | b_id | fun  -- some common is not replicated in result
-- -------------+----+------+-----
--            1 |  1 |    1 | a
--            2 |  2 |    2 | b
--            3 |  3 |    3 | c
-- (3 rows)

select * from natural_join_a a join natural_join_b b on a.some_common = b.some_common;

--  id | some_common | b_id | some_common | fun  -- some common is replicated
-- ----+-------------+------+-------------+-----
--   1 |           1 |    1 |           1 | a
--   2 |           2 |    2 |           2 | b
--   3 |           3 |    3 |           3 | c
-- (3 rows)
