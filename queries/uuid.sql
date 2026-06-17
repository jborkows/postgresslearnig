create table UUID_EXAMPLE (
   value UUID
)


insert into UUID_EXAMPLE 
select gen_random_uuid();


select pg_column_size(value), pg_column_size(value::text) from UUID_EXAMPLE; -- 16 vs 40


with uuid_versions as ( 
select uuidv4() value, 'uuidv4' version union
select gen_random_uuid() value, 'gen_random_uuid' version union
select uuidv7() value, 'v7' version 
)
select value, version , uuid_extract_version(value) from uuid_versions;

select uuid_extract_timestamp(uuidv7()) ; -- uuid7 has timestamp at beginning  can be a good primary key 
