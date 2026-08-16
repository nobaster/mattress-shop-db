
-- Satellite: Характеристики товара (JSONB) + цена


DROP TABLE IF EXISTS dv.sat_product_attrs;

CREATE TABLE dv.sat_product_attrs (
    product_hash_key    CHAR(64)      NOT NULL REFERENCES dv.hub_product(product_hash_key),
    load_date           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    record_source       VARCHAR(100)  NOT NULL,
    product_attrs       JSONB,
    price               NUMERIC(12,2),
    PRIMARY KEY (product_hash_key, load_date)
);

COMMENT ON TABLE dv.sat_product_attrs IS 'Характеристики товара в JSON и цена';