select
country,
jsonb_agg(username),
string_agg(username, ', '),
array_agg(username)
from users where is_pro is true
group by country;


select
country,
count(*) filter (where is_pro is true)
from users 
group by country;


select
country,
bool_and(length(username) > 10) --all in group must match
from users 
group by country;
select
country,
bool_or(length(username) > 10) --at least one
from users 
group by country;


select country, is_pro, count(*)
from users
group by 
grouping sets ((country), (is_pro), ()); --allows grouping by multiple things in single query

--  country | is_pro |  count  
-- ---------+--------+---------
--          |        | 1000000 <- from () empty set
--  DE      |        |  200537 <- from (country)
--  UK      |        |  199362
--  AU      |        |  199863
--  US      |        |  100028
--  FR      |        |   99863
--  CA      |        |  200347
--          | f      |  960414 <- from (is_pro)
--          | t      |   39586
-- (9 rows)


select country, is_pro, count(*)
from users
group by rollup(country, is_pro); 


select country, is_pro, count(*)
from users
group by cube(country, is_pro); --like rollup but gets all possible combinations
