
-- Загрузка данных из staging в Data Vault


-- 1. Хабы

-- Клиенты
INSERT INTO dv.hub_customer (customer_hash_key, customer_id, load_date, record_source)
SELECT DISTINCT
    dv.generate_hash_key(customer_id),
    customer_id,
    NOW(),
    'stg.customer_info'
FROM stg.customer_info
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO dv.hub_customer (customer_hash_key, customer_id, load_date, record_source)
SELECT DISTINCT
    dv.generate_hash_key(customer_id),
    customer_id,
    NOW(),
    'stg.sales_transactions'
FROM stg.sales_transactions
ON CONFLICT (customer_id) DO NOTHING;

-- Товары
INSERT INTO dv.hub_product (product_hash_key, product_id, load_date, record_source)
SELECT DISTINCT
    dv.generate_hash_key(product_id),
    product_id,
    NOW(),
    'stg.product_catalog'
FROM stg.product_catalog
ON CONFLICT (product_id) DO NOTHING;

-- Заказы
INSERT INTO dv.hub_order (order_hash_key, order_id, load_date, record_source)
SELECT DISTINCT
    dv.generate_hash_key(order_id),
    order_id,
    NOW(),
    'stg.sales_transactions'
FROM stg.sales_transactions
ON CONFLICT (order_id) DO NOTHING;

-- Поставщики
INSERT INTO dv.hub_supplier (supplier_hash_key, supplier_id, load_date, record_source)
SELECT DISTINCT
    dv.generate_hash_key(supplier_id),
    supplier_id,
    NOW(),
    'stg.product_catalog'
FROM stg.product_catalog
ON CONFLICT (supplier_id) DO NOTHING;


-- 2. Линки


-- Заказ ↔ Клиент
INSERT INTO dv.link_order_customer (link_order_customer_hash_key, order_hash_key, customer_hash_key, load_date, record_source)
SELECT DISTINCT
    dv.generate_hash_key(o.order_hash_key, c.customer_hash_key),
    o.order_hash_key,
    c.customer_hash_key,
    NOW(),
    'stg.sales_transactions'
FROM stg.sales_transactions st
JOIN dv.hub_order o    ON o.order_id    = st.order_id
JOIN dv.hub_customer c ON c.customer_id = st.customer_id
ON CONFLICT (order_hash_key, customer_hash_key) DO NOTHING;

-- Заказ ↔ Товар
INSERT INTO dv.link_order_product (link_order_product_hash_key, order_hash_key, product_hash_key, load_date, record_source)
SELECT DISTINCT
    dv.generate_hash_key(o.order_hash_key, p.product_hash_key),
    o.order_hash_key,
    p.product_hash_key,
    NOW(),
    'stg.sales_transactions'
FROM stg.sales_transactions st
JOIN dv.hub_order o   ON o.order_id   = st.order_id
JOIN dv.hub_product p ON p.product_id = st.product_id
ON CONFLICT (order_hash_key, product_hash_key) DO NOTHING;


-- 3. Сателлиты

-- Данные клиента
INSERT INTO dv.sat_customer_info (customer_hash_key, load_date, record_source, customer_name, customer_phone, customer_email, customer_city)
SELECT
    c.customer_hash_key,
    st.valid_from,
    'stg.customer_info',
    st.customer_name,
    st.customer_phone,
    st.customer_email,
    st.customer_city
FROM stg.customer_info st
JOIN dv.hub_customer c ON c.customer_id = st.customer_id
ON CONFLICT (customer_hash_key, load_date) DO NOTHING;

-- Сегмент клиента
INSERT INTO dv.sat_customer_segment (customer_hash_key, load_date, record_source, customer_segment)
SELECT
    c.customer_hash_key,
    st.valid_from,
    'stg.customer_info',
    st.customer_segment
FROM stg.customer_info st
JOIN dv.hub_customer c ON c.customer_id = st.customer_id
ON CONFLICT (customer_hash_key, load_date) DO NOTHING;

-- Информация о товаре
INSERT INTO dv.sat_product_info (product_hash_key, load_date, record_source, product_name, product_category, product_brand)
SELECT
    p.product_hash_key,
    st.valid_from,
    'stg.product_catalog',
    st.product_name,
    st.product_category,
    st.product_brand
FROM stg.product_catalog st
JOIN dv.hub_product p ON p.product_id = st.product_id
ON CONFLICT (product_hash_key, load_date) DO NOTHING;

-- Характеристики и цена товара
INSERT INTO dv.sat_product_attrs (product_hash_key, load_date, record_source, product_attrs, price)
SELECT
    p.product_hash_key,
    st.valid_from,
    'stg.product_catalog',
    st.product_attrs,
    st.price
FROM stg.product_catalog st
JOIN dv.hub_product p ON p.product_id = st.product_id
ON CONFLICT (product_hash_key, load_date) DO NOTHING;

-- Статус заказа
INSERT INTO dv.sat_order_status (order_hash_key, load_date, record_source, order_status)
SELECT DISTINCT
    o.order_hash_key,
    st.order_date,
    'stg.sales_transactions',
    st.order_status
FROM stg.sales_transactions st
JOIN dv.hub_order o ON o.order_id = st.order_id
ON CONFLICT (order_hash_key, load_date) DO NOTHING;

-- Детали заказа
INSERT INTO dv.sat_order_details (link_order_product_hash_key, load_date, record_source, quantity, price, discount)
SELECT
    lop.link_order_product_hash_key,
    st.order_date,
    'stg.sales_transactions',
    st.quantity,
    st.price,
    st.discount
FROM stg.sales_transactions st
JOIN dv.hub_order o     ON o.order_id     = st.order_id
JOIN dv.hub_product p   ON p.product_id   = st.product_id
JOIN dv.link_order_product lop
    ON lop.order_hash_key = o.order_hash_key
    AND lop.product_hash_key = p.product_hash_key
ON CONFLICT (link_order_product_hash_key, load_date) DO NOTHING;

-- Товар ↔ Поставщик
INSERT INTO dv.link_product_supplier (link_product_supplier_hash_key, product_hash_key, supplier_hash_key, load_date, record_source)
SELECT DISTINCT
    dv.generate_hash_key(p.product_hash_key, s.supplier_hash_key),
    p.product_hash_key,
    s.supplier_hash_key,
    NOW(),
    'stg.product_catalog'
FROM stg.product_catalog st
JOIN dv.hub_product p   ON p.product_id   = st.product_id
JOIN dv.hub_supplier s  ON s.supplier_id  = st.supplier_id
ON CONFLICT (product_hash_key, supplier_hash_key) DO NOTHING;


-- Проверка

SELECT 'hub_customer' AS tbl, COUNT(*) FROM dv.hub_customer
UNION ALL
SELECT 'hub_product', COUNT(*) FROM dv.hub_product
UNION ALL
SELECT 'hub_order', COUNT(*) FROM dv.hub_order
UNION ALL
SELECT 'hub_supplier', COUNT(*) FROM dv.hub_supplier
UNION ALL
SELECT 'link_order_customer', COUNT(*) FROM dv.link_order_customer
UNION ALL
SELECT 'link_order_product', COUNT(*) FROM dv.link_order_product
UNION ALL
SELECT 'sat_customer_info', COUNT(*) FROM dv.sat_customer_info
UNION ALL
SELECT 'sat_customer_segment', COUNT(*) FROM dv.sat_customer_segment
UNION ALL
SELECT 'sat_product_info', COUNT(*) FROM dv.sat_product_info
UNION ALL
SELECT 'sat_product_attrs', COUNT(*) FROM dv.sat_product_attrs
UNION ALL
SELECT 'sat_order_status', COUNT(*) FROM dv.sat_order_status
UNION ALL
SELECT 'sat_order_details', COUNT(*) FROM dv.sat_order_details;