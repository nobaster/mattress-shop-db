
-- Аналитические представления



-- View 1: Актуальные данные о клиентах


CREATE OR REPLACE VIEW analytics.v_customer_current AS
SELECT
    hc.customer_hash_key,
    hc.customer_id,
    sci.customer_name,
    sci.customer_phone,
    sci.customer_email,
    sci.customer_city,
    scs.customer_segment,
    scs.load_date AS segment_valid_from
FROM dv.hub_customer hc
JOIN LATERAL (
    SELECT *
    FROM dv.sat_customer_info
    WHERE customer_hash_key = hc.customer_hash_key
    ORDER BY load_date DESC
    LIMIT 1
) sci ON TRUE
JOIN LATERAL (
    SELECT *
    FROM dv.sat_customer_segment
    WHERE customer_hash_key = hc.customer_hash_key
    ORDER BY load_date DESC
    LIMIT 1
) scs ON TRUE;

-- View 2: Актуальные данные о товарах
CREATE OR REPLACE VIEW analytics.v_product_current AS
SELECT
    hp.product_hash_key,
    hp.product_id,
    spi.product_name,
    spi.product_category,
    spi.product_brand,
    spa.product_attrs,
    spa.price
FROM dv.hub_product hp
JOIN LATERAL (
    SELECT *
    FROM dv.sat_product_info
    WHERE product_hash_key = hp.product_hash_key
    ORDER BY load_date DESC
    LIMIT 1
) spi ON TRUE
JOIN LATERAL (
    SELECT *
    FROM dv.sat_product_attrs
    WHERE product_hash_key = hp.product_hash_key
    ORDER BY load_date DESC
    LIMIT 1
) spa ON TRUE;


-- View 3: Детали продаж (для отчетов)

CREATE OR REPLACE VIEW analytics.v_sales_details AS
SELECT
    ho.order_id,
    sod.price AS unit_price,
    sod.quantity,
    sod.discount,
    ROUND(sod.price * sod.quantity * (1 - sod.discount / 100), 2) AS total_amount,
    vpc.product_id,
    vpc.product_name,
    vpc.product_category,
    vpc.product_brand,
    vcc.customer_id,
    vcc.customer_name,
    vcc.customer_city,
    vcc.customer_segment,
    sos.order_status,
    sos.load_date AS order_date
FROM dv.link_order_product lop
JOIN dv.hub_order ho ON ho.order_hash_key = lop.order_hash_key
JOIN LATERAL (
    SELECT *
    FROM dv.sat_order_details
    WHERE link_order_product_hash_key = lop.link_order_product_hash_key
    ORDER BY load_date DESC
    LIMIT 1
) sod ON TRUE
JOIN analytics.v_product_current vpc ON vpc.product_hash_key = lop.product_hash_key
JOIN dv.link_order_customer loc ON loc.order_hash_key = ho.order_hash_key
JOIN analytics.v_customer_current vcc ON vcc.customer_hash_key = loc.customer_hash_key
JOIN LATERAL (
    SELECT *
    FROM dv.sat_order_status
    WHERE order_hash_key = ho.order_hash_key
    ORDER BY load_date DESC
    LIMIT 1
) sos ON TRUE
WHERE sos.order_status = 'выполнен';

--LATERAL — позволяет для каждой строки хаба выбрать последнюю версию из сателлита.

-- Проверка

SELECT 'Клиенты (актуальные)' AS view_name, COUNT(*) FROM analytics.v_customer_current
UNION ALL
SELECT 'Товары (актуальные)', COUNT(*) FROM analytics.v_product_current
UNION ALL
SELECT 'Продажи (детали)', COUNT(*) FROM analytics.v_sales_details;

select * from analytics.v_sales_details;