select * from generate_series(1,10);

--  generate_series 
-- -----------------
--                1
--                2
--                3
--                4
--                5
--                6
--                7
--                8
--                9
--               10
-- (10 rows)

select chr(l) from generate_series(65,75) as letters(l);

--  chr 
-- -----
--  A
--  B
--  C
--  D
--  E
--  F
--  G
--  H
--  I
--  J
--  K
-- (11 rows)


select chr(l) || n from generate_series(65,75) as letters(l)
cross join
generate_series(1,10) as n;

select  generate_series('2025-01-01'::date, '2025-01-20'::date, '1 day')::date; -- it can construct date series
