
-- Link: Заказ - Клиент
-- Определяет связь: какой клиент сделал заказ

DROP TABLE IF EXISTS dv.link_order_customer;

CREATE TABLE dv.link_order_customer (
    link_order_customer_hash_key CHAR(64)    PRIMARY KEY,
    order_hash_key               CHAR(64)    NOT NULL REFERENCES dv.hub_order(order_hash_key),
    customer_hash_key            CHAR(64)    NOT NULL REFERENCES dv.hub_customer(customer_hash_key),
    load_date                    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_source                VARCHAR(100) NOT NULL,
    UNIQUE (order_hash_key, customer_hash_key)
);

-- Индексы для ускорения соединений
CREATE INDEX idx_loc_order ON dv.link_order_customer(order_hash_key);
CREATE INDEX idx_loc_customer ON dv.link_order_customer(customer_hash_key);

COMMENT ON TABLE dv.link_order_customer IS 'Связь заказов с клиентами';