-- ============================================================
-- Создание схем для проекта
-- ============================================================

-- Схема для staging-слоя: сырые данные из источника
CREATE SCHEMA IF NOT EXISTS stg;

-- Схема для Data Vault: хабы, линки, сателлиты
CREATE SCHEMA IF NOT EXISTS dv;

-- Схема для аналитики: витрины и представления
CREATE SCHEMA IF NOT EXISTS analytics;

-- Проверяем, что схемы созданы
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('stg', 'dv', 'analytics');