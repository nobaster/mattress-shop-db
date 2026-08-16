
-- Hub: Поставщики


DROP TABLE IF EXISTS dv.hub_supplier;

CREATE TABLE dv.hub_supplier (
    supplier_hash_key   CHAR(64)      PRIMARY KEY,
    supplier_id         VARCHAR(50)   NOT NULL,
    load_date           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    record_source       VARCHAR(100)  NOT NULL,
    UNIQUE (supplier_id)
);

COMMENT ON TABLE dv.hub_supplier IS 'уникальные бизнес-ключи';
COMMENT ON COLUMN dv.hub_supplier.supplier_hash_key IS 'SHA-256 хеш от supplier_id';
COMMENT ON COLUMN dv.hub_supplier.supplier_id IS 'Бизнес-ключ поставщика';
COMMENT ON COLUMN dv.hub_supplier.record_source IS 'Источник записи';