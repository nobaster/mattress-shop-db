
-- Staging-таблица: каталог товаров


DROP TABLE IF EXISTS stg.product_catalog;

CREATE TABLE stg.product_catalog (
    product_id          VARCHAR(50)   NOT NULL,
    product_name        VARCHAR(200),
    product_category    VARCHAR(50),              -- кровать / матрас
    product_brand       VARCHAR(100),
    product_attrs       JSONB,                    -- Характеристики в JSON
    price               NUMERIC(12,2),
    supplier_id         VARCHAR(50),
    supplier_name       VARCHAR(200),
    valid_from          DATE,
    loaded_at           TIMESTAMPTZ   DEFAULT NOW()
);