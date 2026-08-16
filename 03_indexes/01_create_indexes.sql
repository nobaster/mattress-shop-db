
-- Индексы для ускорения загрузки и аналитических запросов


-- Индексы на сателлитах: поиск актуальной версии записи
-- Частый запрос: последняя версия данных по хабу

--Индексы (hash_key, load_date DESC) ускоряют выбор последней версии записи из сателлита.
--Индексы на бизнес-ключи ускоряют поиск при загрузке (проверка «есть ли уже такой ID»).

CREATE INDEX idx_sat_customer_info_hash_date ON dv.sat_customer_info(customer_hash_key, load_date DESC);
CREATE INDEX idx_sat_customer_segment_hash_date ON dv.sat_customer_segment(customer_hash_key, load_date DESC);
CREATE INDEX idx_sat_product_info_hash_date ON dv.sat_product_info(product_hash_key, load_date DESC);
CREATE INDEX idx_sat_product_attrs_hash_date ON dv.sat_product_attrs(product_hash_key, load_date DESC);
CREATE INDEX idx_sat_order_status_hash_date ON dv.sat_order_status(order_hash_key, load_date DESC);
CREATE INDEX idx_sat_order_details_hash_date ON dv.sat_order_details(link_order_product_hash_key, load_date DESC);

-- Индексы на хабах: поиск по бизнес-ключу
CREATE INDEX idx_hub_customer_bk ON dv.hub_customer(customer_id);
CREATE INDEX idx_hub_product_bk ON dv.hub_product(product_id);
CREATE INDEX idx_hub_order_bk ON dv.hub_order(order_id);
CREATE INDEX idx_hub_supplier_bk ON dv.hub_supplier(supplier_id);

