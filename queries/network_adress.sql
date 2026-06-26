create table inet_examples (
   id bigint generated always as identity primary key,
   ip_address INET
);

insert into inet_examples (ip_address) values 
('192.168.1.10/24'),
('10.0.0.1'),
('::1/128'), --ipv6 loopback address
('2001:db8::/32'),
('2001:db8:85a3:8e3:1319:8b2e:270:7248');


with addresses as
(select '192.168.1.10/24' address union all
select '10.0.0.1' union all
select '::1/128' union all
select '2001:db8::/32' union all
select '2001:db8:85a3:8e3:1319:8b2e:270:7248')
select pg_column_size(address), pg_typeof(address), address, pg_column_size(address::inet), pg_typeof(address::inet) from addresses; -- there are differences in favor of inet

select ip_address,
host(ip_address) as host_only,
masklen(ip_address) as mask_length,
network(ip_address) as network_only,
abbrev(ip_address) as abbreviated_ip
from inet_examples;

create table cidr_examples (
   id bigint generated always as identity primary key,
   network_address cidr
);

insert into cidr_examples(network_address) values 
('192.168.0.0/24'),
('10.0.0.0/24'),
('2001:db8::/48');

select * from cidr_examples;

with example as (
 select '08:00:2b:01:02:02' value
)
select pg_column_size(value), pg_column_size(value::macaddr),pg_column_size(value::macaddr8) from example; -- 21,6,8 specialized columns provide smaller sizes
