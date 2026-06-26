create table timestamp_example (
   id serial PRIMARY key,
   "timestamp" timestamptz(6)
);
/*
     "timestamp" timestamptz(0)   -- no fractional seconds                                                                                                              █
     "timestamp" timestamptz(3)   -- milliseconds                                                                                                                       █
     "timestamp" timestamptz(6)   -- microseconds (default)                                                                                                             █

*/


select now()::timestamptz, now()::timestamptz(1), now()::timestamptz(4), now()::timestamptz(0)

select date_trunc('second', now()), now()::timestamptz(0); -- same as timestamptz(0) (almost timestamptz(0) rounds date_trunc removes fractions without rounding)

/**
shows formatting styles, it could be like a moment of running ISO, MDY
Which means accept ISO form 2002-02-01, but also 2/3/2026 with MDY means US format so 2026-02-03
*/
show DateStyle;  

select '2/3/2026'::date;
