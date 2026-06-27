select '[1,5]'::numrange, '[1,5]'::int4range; --[1,5], [1,6) numrange contains fractional data, so here e.g. 1.2
select '[1,6)'::numrange, '[1,6)'::int4range; --[1,6), [1,6)
select numrange(1,5,'[)');

select numrange(1,5,'[)') && numrange(2,3, '[)'); --true
select numrange(1,5,'[)') && numrange(2,6, '[)'); --true
select numrange(1,5,'[)') * numrange(2,6, '[)'); --[2,5)
select '{[3,7), [8,9)}'::int4multirange @> 4; --true @> contains operator
select '{[3,7), [8,9)}'::int4multirange @> 1; --false
--there are more ranges like date and multirange date
