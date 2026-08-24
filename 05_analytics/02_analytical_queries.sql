-- Аналитические запросы с оконными и агрегатными функциями


-- Динамика продаж по месяцам (с накопительным итогом)
-- процент изменения выручки по сравнению с предыдущим месяцем.
SELECT
    DATE_TRUNC('month', order_date)::DATE AS month,
    SUM(total_amount) AS month_sales,
    SUM(SUM(total_amount)) OVER (ORDER BY DATE_TRUNC('month', order_date)) AS cumulative_sales,
    ROUND(
        (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY DATE_TRUNC('month', order_date)))
        / NULLIF(LAG(SUM(total_amount)) OVER (ORDER BY DATE_TRUNC('month', order_date)), 0) * 100,
        2
    ) AS growth_pct
FROM analytics.v_sales_details
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;


-- Сегментация клиентов по сумме покупок

SELECT
    customer_id,
    customer_name,
    customer_segment,
    SUM(total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank_by_spent,
    ROUND(
        SUM(total_amount) / SUM(SUM(total_amount)) OVER () * 100,
        2
    ) AS share_of_total_pct
FROM analytics.v_sales_details
GROUP BY customer_id, customer_name, customer_segment
ORDER BY total_spent DESC;



--товара по выручке в каждой категории

WITH product_sales AS (
    SELECT
        product_category,
        product_name,
        SUM(total_amount) AS revenue,
        RANK() OVER (PARTITION BY product_category ORDER BY SUM(total_amount) DESC) AS rank_in_category
    FROM analytics.v_sales_details
    GROUP BY product_category, product_name
)
SELECT *
FROM product_sales
WHERE rank_in_category <= 3
ORDER BY product_category, revenue DESC;


--Средний чек по городам и доля VIP-клиентов

SELECT
    customer_city,
    COUNT(DISTINCT order_id) AS orders_count,
    ROUND(SUM(total_amount) / COUNT(DISTINCT order_id), 2) AS avg_check,
    COUNT(DISTINCT CASE WHEN customer_segment = 'VIP' THEN order_id END) AS vip_orders,
ROUND(
    COUNT(DISTINCT CASE WHEN customer_segment = 'VIP' THEN order_id END)::NUMERIC / COUNT(DISTINCT order_id) * 100,
    2
) AS vip_share_pct
FROM analytics.v_sales_details
GROUP BY customer_city
ORDER BY avg_check DESC;


--Повторные покупки: интервал между заказами клиента
WITH customer_orders AS (
    SELECT
        customer_id,
        customer_name,
        order_id,
        MIN(order_date) AS order_date
    FROM analytics.v_sales_details
    GROUP BY customer_id, customer_name, order_id
),
ranked_orders AS (
    SELECT
        customer_id,
        customer_name,
        order_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_number
    FROM customer_orders
)
SELECT
    ro1.customer_id,
    ro1.customer_name,
    ro1.order_date AS first_order,
    ro2.order_date AS second_order,
    (ro2.order_date - ro1.order_date) AS days_between
FROM ranked_orders ro1
JOIN ranked_orders ro2
    ON ro1.customer_id = ro2.customer_id
    AND ro1.order_number = 1
    AND ro2.order_number = 2
ORDER BY days_between;