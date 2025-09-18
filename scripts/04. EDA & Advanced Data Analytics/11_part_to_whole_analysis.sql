/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
WITH category_sales AS
(
SELECT
SUM(f.Sales) AS total_sales,
p.Category AS Category
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.Category
)
SELECT
Category,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
ROUND((CAST(total_sales AS FLOAT)/SUM(total_sales) OVER()) * 100 , 2) AS total_percent
FROM category_sales
