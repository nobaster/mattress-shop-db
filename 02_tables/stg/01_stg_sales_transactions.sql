
-- Staging-таблица: транзакции продаж. Моделируем то, что к нам пришли данные из внешней системы



DROP TABLE IF EXISTS stg.sales_transactions;

CREATE TABLE stg.sales_transactions (
    transaction_id      VARCHAR(50)   NOT NULL,   -- Уникальный ID транзакции
    customer_id         VARCHAR(50)   NOT NULL,   -- ID клиента
    customer_name       VARCHAR(200),             -- Имя клиента (сырые данные)
    customer_phone      VARCHAR(50),              -- Телефон клиента
    customer_email      VARCHAR(200),             -- Email клиента
    customer_city       VARCHAR(100),             -- Город клиента
    product_id          VARCHAR(50)   NOT NULL,   -- ID товара
    product_name        VARCHAR(200),             -- Название товара
    product_category    VARCHAR(50),              -- Категория: кровать / матрас
    product_brand       VARCHAR(100),             -- Бренд
    product_attrs       JSONB,                    -- Характеристики товара (JSON)
    price               NUMERIC(12,2),            -- Цена за единицу
    quantity            INT           NOT NULL,   -- Количество
    discount            NUMERIC(5,2)  DEFAULT 0,  -- Скидка в процентах
    order_id            VARCHAR(50)   NOT NULL,   -- ID заказа
    order_date          DATE          NOT NULL,   -- Дата заказа
    order_status        VARCHAR(50),              -- Статус заказа
    supplier_id         VARCHAR(50),              -- ID поставщика
    supplier_name       VARCHAR(200),             -- Название поставщика
    loaded_at           TIMESTAMPTZ   DEFAULT NOW()
);