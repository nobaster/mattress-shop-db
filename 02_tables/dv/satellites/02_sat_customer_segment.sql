
-- Satellite: Сегмент клиента
-- Хранит историю изменения сегмента (VIP / стандарт / новый)


DROP TABLE IF EXISTS dv.sat_customer_segment;

CREATE TABLE dv.sat_customer_segment (
    customer_hash_key   CHAR(64)      NOT NULL REFERENCES dv.hub_customer(customer_hash_key),
    load_date           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    record_source       VARCHAR(100)  NOT NULL,
    customer_segment    VARCHAR(50)   NOT NULL,
    PRIMARY KEY (customer_hash_key, load_date)
);

COMMENT ON TABLE dv.sat_customer_segment IS 'История изменения сегмента клиента';