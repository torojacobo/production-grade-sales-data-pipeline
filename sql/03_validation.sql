-- Final totals by source
SELECT
    source_system,
    COUNT(*) AS total_rows,
    ROUND(SUM(total_sales), 2) AS total_sales,
    ROUND(AVG(total_sales), 2) AS avg_ticket
FROM sales_unified
GROUP BY source_system;


-- Final total unified sales
SELECT
    COUNT(*) AS total_rows,
    ROUND(SUM(total_sales), 2) AS total_sales
FROM sales_unified;


-- Check sales calculation consistency
SELECT *
FROM sales_unified
WHERE ROUND(quantity_sold * unit_price, 2) <> ROUND(total_sales, 2);


-- Check duplicate sales_id by source
SELECT
    sales_id,
    source_system,
    COUNT(*) AS duplicated_count
FROM sales_unified
GROUP BY sales_id, source_system
HAVING COUNT(*) > 1;


-- Sales by region
SELECT
    region,
    COUNT(*) AS total_rows,
    ROUND(SUM(total_sales), 2) AS total_sales
FROM sales_unified
GROUP BY region
ORDER BY total_sales DESC;


-- Sales by category
SELECT
    category,
    COUNT(*) AS total_rows,
    ROUND(SUM(total_sales), 2) AS total_sales
FROM sales_unified
GROUP BY category
ORDER BY total_sales DESC;