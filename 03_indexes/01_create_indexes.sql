--Создаём только индексы на внешний ключ, где ведущая колонка не покрыта UNIQUE

DROP INDEX IF EXISTS idx_hub_customer_bk;
DROP INDEX IF EXISTS idx_hub_product_bk;
DROP INDEX IF EXISTS idx_hub_order_bk;
DROP INDEX IF EXISTS idx_hub_supplier_bk;
DROP INDEX IF EXISTS idx_sat_customer_info_hash_date;
DROP INDEX IF EXISTS idx_sat_customer_segment_hash_date;
DROP INDEX IF EXISTS idx_sat_product_info_hash_date;
DROP INDEX IF EXISTS idx_sat_product_attrs_hash_date;
DROP INDEX IF EXISTS idx_sat_order_status_hash_date;
DROP INDEX IF EXISTS idx_sat_order_details_hash_date;
DROP INDEX IF EXISTS idx_loc_order;
DROP INDEX IF EXISTS idx_lop_order;
DROP INDEX IF EXISTS idx_lps_product;


CREATE INDEX IF NOT EXISTS idx_loc_customer ON dv.link_order_customer(customer_hash_key);
CREATE INDEX IF NOT EXISTS idx_lop_product ON dv.link_order_product(product_hash_key);
CREATE INDEX IF NOT EXISTS idx_lps_supplier ON dv.link_product_supplier(supplier_hash_key);