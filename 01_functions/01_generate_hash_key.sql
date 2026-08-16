
-- Функция генерации хеш-ключа для Data Vault



DROP FUNCTION IF EXISTS dv.generate_hash_key(VARIADIC TEXT[]);

-- Создаём функцию
CREATE OR REPLACE FUNCTION dv.generate_hash_key(VARIADIC params TEXT[])
RETURNS CHAR(64)
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
    concat_string TEXT;
BEGIN
    -- Объединяем все переданные параметры через разделитель '||'
    concat_string := array_to_string(params, '||');

    RETURN encode(sha256(convert_to(concat_string, 'UTF8')), 'hex');
END;
$$;
