-- 1. Row count by source table
SELECT 'crm1_raw' AS table_name, COUNT(*) AS total_rows
FROM crm1_raw
UNION ALL
SELECT 'crm2_raw' AS table_name, COUNT(*) AS total_rows
FROM crm2_raw;


-- 2. Preview CRM 1
SELECT *
FROM crm1_raw
LIMIT 5;


-- 3. Preview CRM 2
SELECT *
FROM crm2_raw
LIMIT 5;


-- 4. Duplicate sales_id in CRM 1
SELECT
    sales_id,
    COUNT(*) AS duplicated_count
FROM crm1_raw
GROUP BY sales_id
HAVING COUNT(*) > 1;


-- 5. Duplicate sales_id in CRM 2
SELECT
    sales_id,
    COUNT(*) AS duplicated_count
FROM crm2_raw
GROUP BY sales_id
HAVING COUNT(*) > 1;


-- 6. Validate sales calculation CRM 1
SELECT *
FROM crm1_raw
WHERE ROUND(quantity_sold * unit_price, 2) <> ROUND(total_sales, 2);


-- 7. Validate sales calculation CRM 2
SELECT *
FROM crm2_raw
WHERE ROUND(quantity_sold * unit_price, 2) <> ROUND(total_sales, 2);


-- 8. Sales totals by source
SELECT
    'CRM_1' AS source_system,
    COUNT(*) AS total_rows,
    ROUND(SUM(total_sales), 2) AS total_sales
FROM crm1_raw
UNION ALL
SELECT
    'CRM_2' AS source_system,
    COUNT(*) AS total_rows,
    ROUND(SUM(total_sales), 2) AS total_sales
FROM crm2_raw;