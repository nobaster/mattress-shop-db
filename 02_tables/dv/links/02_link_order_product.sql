
-- Link: Заказ - Товар
-- Определяет связь: какой товар входит в заказ

DROP TABLE IF EXISTS dv.link_order_product;

CREATE TABLE dv.link_order_product (
    link_order_product_hash_key CHAR(64)    PRIMARY KEY,
    order_hash_key              CHAR(64)    NOT NULL REFERENCES dv.hub_order(order_hash_key),
    product_hash_key            CHAR(64)    NOT NULL REFERENCES dv.hub_product(product_hash_key),
    load_date                   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_source               VARCHAR(100) NOT NULL,
    UNIQUE (order_hash_key, product_hash_key)
);

-- Индексы для ускорения соединений
CREATE INDEX idx_lop_order ON dv.link_order_product(order_hash_key);
CREATE INDEX idx_lop_product ON dv.link_order_product(product_hash_key);

COMMENT ON TABLE dv.link_order_product IS 'Связь заказов с товарами';