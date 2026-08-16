
-- Анализ производительности запросов

-- 3. Сравнение: запрос без индекса (если бы его не было)
-- Отключаем использование индексов для демонстрации
SET enable_indexscan = OFF;
SET enable_bitmapscan = OFF;

EXPLAIN ANALYZE
SELECT *
FROM dv.hub_customer
WHERE customer_id = 'C001';

-- Включаем обратно
SET enable_indexscan = ON;
SET enable_bitmapscan = ON;

-- Тот же запрос с индексами
EXPLAIN ANALYZE
SELECT *
FROM dv.hub_customer
WHERE customer_id = 'C001';

-- В случае без индексов, используется Seq скан, что показывает, что идет полный перебор
--В случае с индексами идет Index Scan, нашел сразу нужную строку