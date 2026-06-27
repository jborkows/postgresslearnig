select to_tsvector('I like learning about new things');
--  'learn':3 'like':2 'new':5 'thing':6
select to_tsvector('I like learning about new things') @@ to_tsquery('learning'); --true
select to_tsquery('learning') @@ to_tsvector('I like learning about new things')  ; --true
select to_tsquery('learn') @@ to_tsvector('I like learning about new things')  ; --true
select to_tsquery('learnx') @@ to_tsvector('I like learning about new things')  ; --false

create table ts_example (
   id bigint generated ALWAYS as identity PRIMARY  key,
   content text,
   --search_vector tsvector generated ALWAYS as (to_tsvector(content)) stored --generation expression is not immutable
   search_vector tsvector generated ALWAYS as (to_tsvector('english',content)) stored --generation expression is not immutable
);

insert into ts_example (content) values ('A simple text');

select to_tsquery('Simple') @@  search_vector from ts_example ; --true
select to_tsquery('Large') @@  search_vector from ts_example ; --false
update ts_example set content = concat(content, ' is sometimes large');
select to_tsquery('Large') @@  search_vector from ts_example ; --true
select * from ts_example where  to_tsquery('Large') @@  search_vector ; 

