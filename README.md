# Start playing
```bash 
make restart
PGPASSWORD=postgres psql -h localhost -U postgres -d postgres # probably more secure ways check .pgpass
```

# DB Info
```bash 
postgres=# \d
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | foo    | table | postgres
 public | foomoo | table | postgres
(2 rows)

postgres=# \d foo
                Table "public.foo"
 Column |  Type   | Collation | Nullable | Default
--------+---------+-----------+----------+---------
 id     | integer |           |          |

postgres=#
```
Configuration can be done with .psqlrc

# Datatypes
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
- scale how many digits on right side of dot


