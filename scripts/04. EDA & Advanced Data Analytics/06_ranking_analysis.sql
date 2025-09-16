/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
p.product_name,
SUM(f.Sales) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name 
ORDER BY total_revenue DESC

-- Complex but Flexibly Ranking Using Window Functions
SELECT
product_name,
total_revenue
FROM(
SELECT 
RANK() OVER(ORDER BY SUM(f.Sales) DESC) AS ranking,
p.product_name,
SUM(f.Sales) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
)t
WHERE ranking <= 5

-- What are the 5 worst-performing products in terms of sales?
SELECT
product_name,
total_revenue
FROM
(
SELECT
RANK() OVER(ORDER BY SUM(f.Sales)) AS ranking,
p.product_name,
SUM(f.Sales) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
)t
WHERE ranking <= 5

-- Find the top 10 customers who have generated the highest revenue
SELECT
customer_key,
first_name,
last_name,
total_revenue
FROM(
SELECT
RANK() OVER(ORDER BY SUM(f.Sales) DESC) AS ranking,
c.customer_key,
c.first_name,
c.last_name,
SUM(f.Sales) As total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
)t
WHERE ranking <= 10

-- The 3 customers with the fewest orders placed
SELECT
customer_key,
first_name,
last_name,
total_revenue
FROM(
SELECT
RANK() OVER(ORDER BY SUM(f.Sales)) AS ranking,
c.customer_key,
c.first_name,
c.last_name,
SUM(f.Sales) As total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
)t
WHERE ranking <= 3
