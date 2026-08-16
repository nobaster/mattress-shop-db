
-- Hub: Клиенты
-- Хранит уникальные бизнес-ключи клиентов


DROP TABLE IF EXISTS dv.hub_customer;

CREATE TABLE dv.hub_customer (
    customer_hash_key   CHAR(64)      PRIMARY KEY,  -- PK: SHA-256 от customer_id
    customer_id         VARCHAR(50)   NOT NULL,     -- Бизнес-ключ из источника
    load_date           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    record_source       VARCHAR(100)  NOT NULL,     -- Откуда пришли данные
    UNIQUE (customer_id)
);

-- Комментарии к таблице и колонкам (для документации)
COMMENT ON TABLE dv.hub_customer IS 'уникальные бизнес-ключи';
COMMENT ON COLUMN dv.hub_customer.customer_hash_key IS 'SHA-256 хеш от customer_id';
COMMENT ON COLUMN dv.hub_customer.customer_id IS 'Бизнес-ключ клиента из Внешней системы';
COMMENT ON COLUMN dv.hub_customer.record_source IS 'Источник записи';