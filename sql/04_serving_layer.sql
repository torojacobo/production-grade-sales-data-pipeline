DROP VIEW IF EXISTS analytics_sales_summary;

CREATE VIEW analytics_sales_summary AS
SELECT
    source_system,
    region,
    category,
    COUNT(*) AS transactions,
    ROUND(SUM(total_sales), 2) AS total_sales,
    ROUND(AVG(total_sales), 2) AS avg_ticket
FROM sales_unified
GROUP BY
    source_system,
    region,
    category;