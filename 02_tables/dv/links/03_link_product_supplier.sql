
-- Link: Товар - Поставщик
-- Фиксирует связь: какой поставщик поставляет товар


DROP TABLE IF EXISTS dv.link_product_supplier;

CREATE TABLE dv.link_product_supplier (
    link_product_supplier_hash_key CHAR(64)    PRIMARY KEY,
    product_hash_key               CHAR(64)    NOT NULL REFERENCES dv.hub_product(product_hash_key),
    supplier_hash_key              CHAR(64)    NOT NULL REFERENCES dv.hub_supplier(supplier_hash_key),
    load_date                      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_source                  VARCHAR(100) NOT NULL,
    UNIQUE (product_hash_key, supplier_hash_key)
);

-- Индексы для ускорения соединений
CREATE INDEX idx_lps_product ON dv.link_product_supplier(product_hash_key);
CREATE INDEX idx_lps_supplier ON dv.link_product_supplier(supplier_hash_key);

COMMENT ON TABLE dv.link_product_supplier IS 'Связь товаров с поставщиками';