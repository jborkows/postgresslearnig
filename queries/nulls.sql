select '1 = null' condition,  1 = null result
union all
select '1 is not distinct from 1', 1 is not distinct from 1
union all
select '1 is distinct from null', 1 is distinct from null;

--         condition         | result 
-- --------------------------+--------
--  1 = null                 | 
--  1 is not distinct from 1 | t
--  1 is distinct from null  | t


select COALESCE(null,1,null,2);
select nullif(1,2) when_not_equal, nullif(1,1) when_equal;

--  when_not_equal | when_equal 
-- ----------------+------------
--               1 |           

with aaa as
(select 1 id)
select * from aaa where id in (1,null);  --1 row
with aaa as
(select 1 id)
select * from aaa where id not in (2,null);  --0 rows
