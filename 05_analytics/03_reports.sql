
-- Отчёты для визуализации

--Продажи по месяцам и категориям (для сводной таблицы)
-- готовый источник для графика «Динамика продаж по категориям»
SELECT
    DATE_TRUNC('month', order_date)::DATE AS month,
    product_category,
    COUNT(*) AS orders_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_amount), 2) AS revenue
FROM analytics.v_sales_details
GROUP BY DATE_TRUNC('month', order_date), product_category
ORDER BY month, product_category;



--Клиенты: сегмент, город, потрачено, средний чек
--Сводка по клиентам
SELECT
    customer_id,
    customer_name,
    customer_city,
    customer_segment,
    COUNT(DISTINCT order_id) AS orders_count,
    ROUND(SUM(total_amount), 2) AS total_spent,
    ROUND(AVG(total_amount), 2) AS avg_check,
    MIN(order_date)::DATE AS first_purchase,
    MAX(order_date)::DATE AS last_purchase
FROM analytics.v_sales_details
GROUP BY customer_id, customer_name, customer_city, customer_segment
ORDER BY total_spent DESC;