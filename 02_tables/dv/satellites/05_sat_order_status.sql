
-- Satellite: Статус заказа
-- Хранит историю изменения статуса


DROP TABLE IF EXISTS dv.sat_order_status;

CREATE TABLE dv.sat_order_status (
    order_hash_key      CHAR(64)      NOT NULL REFERENCES dv.hub_order(order_hash_key),
    load_date           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    record_source       VARCHAR(100)  NOT NULL,
    order_status        VARCHAR(50)   NOT NULL,
    PRIMARY KEY (order_hash_key, load_date)
);

COMMENT ON TABLE dv.sat_order_status IS 'История изменения статуса заказа';