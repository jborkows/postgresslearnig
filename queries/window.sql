-- Window function demo data in a single table: window_example
-- 4 users with distinct price profiles, 80-100 orders each.

DROP TABLE IF EXISTS window_example;

CREATE TABLE window_example (
    id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    order_id bigint NOT NULL,
    user_id bigint NOT NULL,
    username character varying(255) NOT NULL,
    order_date date NOT NULL,
    price numeric(10,2) NOT NULL
);

-- Generate 80-100 orders per user with distinct price profiles
INSERT INTO window_example (order_id, user_id, username, order_date, price)
SELECT
    n AS order_id,
    u.user_id,
    u.username,
    ('2024-01-01'::date + floor(random() * 25)::int) AS order_date,
    round(
        CASE u.user_id
            WHEN 1 THEN 10  + random() * 90     -- low:     $10-$100
            WHEN 2 THEN 100 + random() * 400    -- mid:     $100-$500
            WHEN 3 THEN 500 + random() * 1500   -- high:    $500-$2000
            WHEN 4 THEN 1000 + random() * 4000  -- premium: $1000-$5000
        END::numeric, 2
    ) AS price
FROM (
    VALUES
        (1, 'alice_low'),
        (2, 'bob_mid'),
        (3, 'carol_high'),
        (4, 'dave_premium')
) AS u(user_id, username)
CROSS JOIN generate_series(1, floor(80 + random() * 21)::int) AS n;

-- Sanity check
SELECT
    user_id,
    username,
    count(*) AS order_count,
    min(order_id) AS first_order_id,
    max(order_id) AS last_order_id,
    min(order_date) AS earliest_date,
    max(order_date) AS latest_date,
    round(avg(price), 2) AS avg_price,
    min(price) AS min_price,
    max(price) AS max_price
FROM window_example
GROUP BY user_id, username
ORDER BY user_id;
