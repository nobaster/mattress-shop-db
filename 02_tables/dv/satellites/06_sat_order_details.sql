
-- Satellite: Детали заказа (привязан к линку заказ-товар)
-- Количество, цена, скидка по каждой позиции


DROP TABLE IF EXISTS dv.sat_order_details;

CREATE TABLE dv.sat_order_details (
    link_order_product_hash_key CHAR(64)    NOT NULL REFERENCES dv.link_order_product(link_order_product_hash_key),
    load_date                   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_source               VARCHAR(100) NOT NULL,
    quantity                    INT          NOT NULL,
    price                       NUMERIC(12,2),
    discount                    NUMERIC(5,2) DEFAULT 0,
    PRIMARY KEY (link_order_product_hash_key, load_date)
);

COMMENT ON TABLE dv.sat_order_details IS 'Детали позиции заказа: количество, цена, скидка';

--Привязка к линку, а не к хабу. Потому что количество и цена относятся к конкретной паре «заказ + товар».

--Один и тот же товар в разных заказах имеет разные детали.