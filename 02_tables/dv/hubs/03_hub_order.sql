
-- Hub: Заказы

DROP TABLE IF EXISTS dv.hub_order;

CREATE TABLE dv.hub_order (
    order_hash_key      CHAR(64)      PRIMARY KEY,
    order_id            VARCHAR(50)   NOT NULL,
    load_date           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    record_source       VARCHAR(100)  NOT NULL,
    UNIQUE (order_id)
);

COMMENT ON TABLE dv.hub_order IS ' уникальные бизнес-ключи заказов';
COMMENT ON COLUMN dv.hub_order.order_hash_key IS 'SHA-256 хеш от order_id';
COMMENT ON COLUMN dv.hub_order.order_id IS 'Бизнес-ключ клиента из Внешней системы';
COMMENT ON COLUMN dv.hub_order.record_source IS 'Источник записи';