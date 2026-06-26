select '1'::json, '1'::jsonb, pg_column_size('1'::json), pg_column_size('1'::jsonb); --jsonb is larger but... json is stored as text, jsonb is preprocessed one binary which enable some additional information
select '1'::json, '1'::jsonb, pg_typeof('1'::json), pg_typeof('1'::jsonb);

with example as (
   select '{"aa":3, "bb":    "aaa"}' value --blank spaces on purpose
)
select value, value::json, value::jsonb from example; --jsonb strips the additional blanks, rest keep it

with jsob_keeps_single_key as (
   select '{"aa":3, "aa":    "5"}' value 
)
select value, value::json, value::jsonb from jsob_keeps_single_key; --jsonb keeps only aa:5

--select '{aaaa}'::json; --it will say that json is invalid


with complex_json as (
   select '{
      "string":"hello",
      "number":23,
      "booolean":true,
      "null":null,
      "array":[1,2,3],
      "object":{"key":"aKey", "value":"aValue"}
   }'::jsonb anJson
)
select anJson->'string' quoted_string, anJson->>'string' unquoted_string, anJson->'object'->>'key', anJson->'array'->1 from complex_json;
