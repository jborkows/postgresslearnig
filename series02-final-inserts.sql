--
-- Intro to Postgres - Series 02 Sample Data (scalable version)
--
-- Changes from the original:
--   * No indexes are created here (create them manually to experiment).
--   * Added `birth_date` to users with random dates between 1980 and 2021.
--   * Data is generated with generate_series for much larger volumes.
--
-- How many rows to generate (edit the numbers in generate_series() below)
--

-- Clean up if tables exist (correct order due to foreign key)
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS users CASCADE;

--
-- Users table
--

CREATE TABLE users (
    id bigint NOT NULL,
    name character varying(255),
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(255),
    status character varying(255) NOT NULL,
    country character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    birth_date date NOT NULL
);

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE users_id_seq OWNED BY users.id;
ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
ALTER TABLE ONLY users ADD CONSTRAINT users_pkey PRIMARY KEY (id);

--
-- Orders table
--

CREATE TABLE orders (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    price numeric(10,2) NOT NULL,
    discount numeric(10,2),
    total numeric(10,2),
    shipping_country character varying(255) NOT NULL,
    region character varying(255) NOT NULL,
    category character varying(255) NOT NULL,
    product_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;
ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);
ALTER TABLE ONLY orders ADD CONSTRAINT orders_pkey PRIMARY KEY (id);

--
-- Generate users
--

INSERT INTO users (
    name,
    username,
    email,
    phone,
    status,
    country,
    email_verified_at,
    deleted_at,
    created_at,
    updated_at,
    birth_date
)
SELECT
    'User ' || n AS name,
    'user' || n AS username,
    'user' || n || '@example.com' AS email,
    CASE
        WHEN random() > 0.5 THEN '+1-555-' || lpad((1000 + (random() * 8999)::int)::text, 4, '0')
    END AS phone,
    (ARRAY['active', 'inactive', 'pending'])[1 + (random() * 2)::int] AS status,
    (ARRAY['US', 'CA', 'UK', 'AU', 'DE', 'FR'])[1 + (random() * 5)::int] AS country,
    CASE
        WHEN random() > 0.3 THEN timestamp '2023-01-01' + random() * interval '3 years'
    END AS email_verified_at,
    CASE
        WHEN random() > 0.85 THEN timestamp '2023-01-01' + random() * interval '3 years'
    END AS deleted_at,
    timestamp '2023-01-01' + random() * interval '3 years' AS created_at,
    timestamp '2023-01-01' + random() * interval '3 years' AS updated_at,
    ('1980-01-01'::date + (random() * ('2021-12-31'::date - '1980-01-01'::date))::int) AS birth_date
FROM generate_series(1, 1000000) AS n;

--
-- Add is_pro flag to users (4% chance of being true)
--

ALTER TABLE users ADD COLUMN is_pro boolean NOT NULL DEFAULT false;

UPDATE users
SET is_pro = true
WHERE random() < 0.04;

--
-- Add first_name and last_name to users
--

ALTER TABLE users ADD COLUMN first_name character varying(255);
ALTER TABLE users ADD COLUMN last_name character varying(255);

UPDATE users
SET
    first_name = (ARRAY['John','Jane','Alex','Sarah','Michael','Emily','David','Emma','James','Olivia'])[1 + (random() * 9)::int],
    last_name = (ARRAY['Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis','Rodriguez','Martinez'])[1 + (random() * 9)::int];

--
-- Generate orders
--

INSERT INTO orders (
    customer_id,
    price,
    discount,
    total,
    shipping_country,
    region,
    category,
    product_id,
    created_at,
    updated_at
)
SELECT
    1 + (random() * 99999)::bigint AS customer_id,
    round((random() * 1000)::numeric, 2) AS price,
    CASE
        WHEN random() > 0.7 THEN round((random() * 100)::numeric, 2)
    END AS discount,
    round((random() * 1000)::numeric, 2) AS total,
    (ARRAY['US', 'CA', 'UK', 'AU', 'DE', 'FR'])[1 + (random() * 5)::int] AS shipping_country,
    (ARRAY['North', 'South', 'East', 'West', 'Central'])[1 + (random() * 4)::int] AS region,
    (ARRAY['electronics', 'clothing', 'home', 'sports', 'books', 'toys'])[1 + (random() * 5)::int] AS category,
    1 + (random() * 9999)::bigint AS product_id,
    timestamp '2023-01-01' + random() * interval '3 years' AS created_at,
    timestamp '2023-01-01' + random() * interval '3 years' AS updated_at
FROM generate_series(1, 1000000) AS n;

--
-- Constraints
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES users(id);

--
-- NO INDEXES ARE CREATED HERE.
-- Create them afterward to compare query plans, e.g.:
--
--   CREATE INDEX users_birth_date_idx ON users USING btree (birth_date);
--   CREATE INDEX users_country_idx ON users USING btree (country);
--   CREATE INDEX orders_created_at_idx ON orders USING btree (created_at);
--
-- Then run:
--
--   ANALYZE users;
--   ANALYZE orders;
--

ANALYZE users;
ANALYZE orders;
