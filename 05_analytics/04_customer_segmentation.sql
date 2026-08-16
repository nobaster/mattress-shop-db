
-- Своя Логика сегментации клиентов на основе RFM-метрик, а не из сателита


-- Шаг 1: Считаем RFM-метрики по каждому клиенту
-- R (Recency) — сколько дней прошло с последней покупки
-- F (Frequency) — сколько заказов сделал
-- M (Monetary) — сколько всего потратил

CREATE OR REPLACE VIEW analytics.v_customer_rfm AS
SELECT
    customer_id,
    customer_name,
    customer_city,
    COUNT(DISTINCT order_id) AS frequency,
    ROUND(SUM(total_amount), 2) AS monetary,
    (CURRENT_DATE - MAX(order_date)::DATE) AS recency_days
FROM analytics.v_sales_details
GROUP BY customer_id, customer_name, customer_city;


-- Шаг 2: Присваиваем сегмент по правилам
SELECT
    customer_id,
    customer_name,
    customer_city,
    frequency,
    monetary,
    recency_days,
    CASE
        WHEN monetary >= 150000 AND frequency >= 2 AND recency_days <= 365 THEN 'VIP'
        WHEN monetary >= 80000 OR frequency >= 3 THEN 'Лояльный'
        WHEN recency_days <= 180 THEN 'Активный'
        ELSE 'Спящий'
    END AS calculated_segment
FROM analytics.v_customer_rfm
ORDER BY monetary DESC;



-- Шаг 3: Сегментация товаров по выручке и количеству продаж
SELECT
    product_category,
    product_name,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_amount), 2) AS revenue,
    CASE
        WHEN SUM(total_amount) >= 150000 THEN 'Хит'
        WHEN SUM(total_amount) >= 80000 THEN 'Средний'
        ELSE 'Низкий'
    END AS product_segment
FROM analytics.v_sales_details
GROUP BY product_category, product_name
ORDER BY revenue DESC;