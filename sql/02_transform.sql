DROP TABLE IF EXISTS crm1_staging;
DROP TABLE IF EXISTS crm2_staging;
DROP TABLE IF EXISTS sales_unified;


CREATE TABLE crm1_staging AS
SELECT
    sales_id,
    CAST(product_id AS TEXT) AS product_id,
    store_id,
    product_name,
    brand,
    category,
    volume_ml,
    alcohol_percentage,
    store_name,
    city,
    state,
    region,
    store_type,
    REPLACE(sales_date, '/', '-') AS sales_date,
    quantity_sold,
    unit_price,
    total_sales,
    email,
    transaction_id,
    payment_method,
    'CRM_1' AS source_system,
    CURRENT_TIMESTAMP AS ingestion_timestamp
FROM crm1_raw;


CREATE TABLE crm2_staging AS
SELECT
    sales_id,
    CAST(product_id AS TEXT) AS product_id,
    store_id,
    product_name,
    brand,
    category,
    volume_ml,
    alcohol_percentage,
    store_name,
    city,
    state,
    region,
    store_type,
    sales_date,
    quantity_sold,
    unit_price,
    total_sales,
    NULL AS email,
    NULL AS transaction_id,
    NULL AS payment_method,
    'CRM_2' AS source_system,
    CURRENT_TIMESTAMP AS ingestion_timestamp
FROM crm2_raw;


CREATE TABLE sales_unified AS
SELECT *
FROM crm1_staging

UNION ALL

SELECT *
FROM crm2_staging;