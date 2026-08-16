
-- Satellite: Основная информация о товаре
-- Название, категория, бренд


DROP TABLE IF EXISTS dv.sat_product_info;

CREATE TABLE dv.sat_product_info (
    product_hash_key    CHAR(64)      NOT NULL REFERENCES dv.hub_product(product_hash_key),
    load_date           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    record_source       VARCHAR(100)  NOT NULL,
    product_name        VARCHAR(200),
    product_category    VARCHAR(50),   -- кровать / матрас
    product_brand       VARCHAR(100),
    PRIMARY KEY (product_hash_key, load_date)
);

COMMENT ON TABLE dv.sat_product_info IS 'Основные атрибуты товара';