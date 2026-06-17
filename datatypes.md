
# Data types
```sql 
create table FooMoo (
one int2, --alias see down
two int4,
third int8
);
```
```bash
postgres-# \d FooMoo
               Table "public.foomoo"
 Column |   Type   | Collation | Nullable | Default
--------+----------+-----------+----------+---------
 one    | smallint |           |          |
 two    | integer  |           |          |
 third  | bigint   |           |          |

```
other aliases decimal for numeric.
## Numeric 
(precision, scale):
- precision how many digits
- scale how many digits on right side of dot (In reality dot can be "moved" see below with negative scale)

```bash
postgres=# select 12.345::numeric(5,3);
 numeric
---------
  12.345
(1 row)

postgres=# select 12.345::numeric(5,2);
 numeric
---------
   12.35
(1 row)

postgres=# select 123.345::numeric(5,3);
ERROR:  numeric field overflow
DETAIL:  A field with precision 5, scale 3 must round to an absolute value less than 10^2.
postgres=# select 123.34::numeric(5,3);
ERROR:  numeric field overflow
DETAIL:  A field with precision 5, scale 3 must round to an absolute value less than 10^2.
postgres=# select 12.34::numeric(5,3);
 numeric
---------
  12.340
(1 row)

postgres=# select 12.34::numeric(5,0);
 numeric
---------
      12
(1 row)

postgres=# select 12.34::numeric(5); --same as above
 numeric
---------
      12
(1 row)

postgres=# select 12.34::numeric(5, -2);
 numeric
---------
       0
(1 row)

postgres=# select 1112.34::numeric(5, -2);
 numeric
---------
    1100
(1 row)
```
## Real
```sql
create table Foo (
one float4,
second float8,
third_a float(24),
third_b float(25)
);
```
```bash
postgres=# \d Foo
                     Table "public.foo"
 Column  |       Type       | Collation | Nullable | Default
---------+------------------+-----------+----------+---------
 one     | real             |           |          |
 second  | double precision |           |          |
 third_a | real             |           |          |
 third_b | double precision |           |          |

```

## Money
```sql
drop table Foo;
create table Foo (
value money
);
insert into Foo values (1.0);
insert into Foo values (2);
insert into Foo values ('$2.2');
select * from Foo;
```
```
 value 
-------
 $1.00
 $2.00
 $2.20
(3 rows)
```
warning money loose precision
```sql 

select 199::money
	union
select 199.91::money
	union
select 199.913::money
	union
select 199.918::money
```
```

  money  
---------
 $199.00
 $199.91
 $199.92
(3 rows)
```
The money currency is done using lc_monetary (changing does not change values)
## Checking types
```sql
select pg_typeof(100::int8)
```
Column size check pg_column_size

## Text
- char or character
- character varying or varchar
- text
```sql

create table Foo (
one char, -- no performance gain of using char or char(fixed number e.g. 50)
two varchar,
third varchar(30),
aText text -- cannot limit text
);
```
## Domain
Wraps types with constraint 
```sql
create DOMAIN unsigned as int8 constraint non_negative check (value > 0 or value = 0);
create table Foo (
   time unsigned
);
insert into Foo values (5);
insert into Foo values (0);
insert into Foo values (-5);
```
```bash
INSERT 0 1
INSERT 0 1
ERROR:  value for domain unsigned violates check constraint "non_negative"
```
