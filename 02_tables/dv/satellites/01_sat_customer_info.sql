
-- Satellite: Данные клиента
-- Хранит описательные атрибуты и их историю


DROP TABLE IF EXISTS dv.sat_customer_info;

CREATE TABLE dv.sat_customer_info (
    customer_hash_key   CHAR(64)      NOT NULL REFERENCES dv.hub_customer(customer_hash_key),
    load_date           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    record_source       VARCHAR(100)  NOT NULL,
    customer_name       VARCHAR(200),
    customer_phone      VARCHAR(50),
    customer_email      VARCHAR(200),
    customer_city       VARCHAR(100),
    PRIMARY KEY (customer_hash_key, load_date)
);

COMMENT ON TABLE dv.sat_customer_info IS 'Сателлит с персональными данными клиента';