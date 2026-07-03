create sequence seq
as bigint 
INCREMENT 1 --optional
start 11 -- must be bigger that minvalue
minvalue 10  --optional
maxvalue 1000 --optional
cache 1; --how many entries to keep in memory default 1

select nextval('seq'), currval('seq'), nextval('seq') ; -- currval shows value in this session 
select setval('seq', 11); --set val
