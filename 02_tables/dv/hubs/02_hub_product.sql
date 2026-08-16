
-- Hub: Товары

DROP TABLE IF EXISTS dv.hub_product;

CREATE TABLE dv.hub_product (
    product_hash_key    CHAR(64)      PRIMARY KEY,
    product_id          VARCHAR(50)   NOT NULL,
    load_date           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    record_source       VARCHAR(100)  NOT NULL,
    UNIQUE (product_id)
);

COMMENT ON TABLE dv.hub_product IS 'уникальные бизнес-ключи товаров';
COMMENT ON COLUMN dv.hub_product.product_hash_key IS 'SHA-256 хеш от product_id';
COMMENT ON COLUMN dv.hub_product.product_id IS 'Бизнес-ключ клиента из Внешней системы';
COMMENT ON COLUMN dv.hub_product.record_source IS 'Источник записи';