
-- Staging-таблица: данные клиентов (обновления)


DROP TABLE IF EXISTS stg.customer_info;

CREATE TABLE stg.customer_info (
    customer_id         VARCHAR(50)   NOT NULL,
    customer_name       VARCHAR(200),
    customer_phone      VARCHAR(50),
    customer_email      VARCHAR(200),
    customer_city       VARCHAR(100),
    customer_segment    VARCHAR(50),              -- VIP / стандарт / новый
    valid_from          DATE,                     -- С какой даты актуальны данные
    loaded_at           TIMESTAMPTZ   DEFAULT NOW()
);