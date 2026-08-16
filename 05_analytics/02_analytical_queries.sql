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
    COUNT(*) AS orders_count,
    ROUND(AVG(total_amount), 2) AS avg_check,
    SUM(CASE WHEN customer_segment = 'VIP' THEN 1 ELSE 0 END) AS vip_orders,
    ROUND(
        SUM(CASE WHEN customer_segment = 'VIP' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*) * 100,
        2
    ) AS vip_share_pct
FROM analytics.v_sales_details
GROUP BY customer_city
ORDER BY avg_check DESC;



--Повторные покупки: интервал между заказами клиента
WITH customer_orders AS (
    SELECT DISTINCT
        customer_id,
        customer_name,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_number
    FROM analytics.v_sales_details
)
SELECT
    co1.customer_id,
    co1.customer_name,
    co1.order_date AS first_order,
    co2.order_date AS second_order,
    (co2.order_date - co1.order_date) AS days_between
FROM customer_orders co1
JOIN customer_orders co2
    ON co1.customer_id = co2.customer_id
    AND co1.order_number = 1
    AND co2.order_number = 2
ORDER BY days_between;