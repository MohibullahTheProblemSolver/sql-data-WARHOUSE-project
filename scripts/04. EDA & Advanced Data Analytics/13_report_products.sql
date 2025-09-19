/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

IF OBJECT_ID('gold.products_report','V') IS NOT NULL
DROP VIEW gold.products_report;

GO

CREATE VIEW gold.products_report AS

WITH base_query AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales & dim_product 
---------------------------------------------------------------------------*/
(
SELECT
f.order_number,
f.customer_key,
f.product_key,
f.order_date,
f.Sales,
f.Quantity,
p.product_name,
p.Category,
p.Subcategory,
p.product_cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
)
, product_aggregation AS
(
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT
product_key,
product_name,
Category,
Subcategory,
product_cost,
MAX(order_date) AS last_order_date,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
COUNT(order_number) AS total_orders,
SUM(Sales) AS total_sales,
SUM(Quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customers,
ROUND(AVG(CAST(Sales AS FLOAT) / NULLIF(Quantity, 0)),1) AS avg_selling_price
FROM base_query
GROUP BY 
	product_key,
	product_name,
	Category,
	Subcategory,
	product_cost
)
SELECT
product_key,
product_name,
Category,
Subcategory,
product_cost,
avg_selling_price,
last_order_date,
DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_by_month,
lifespan,
total_orders,
total_sales,
CASE 
	WHEN total_sales > 50000 THEN 'High-Performers'
	WHEN total_sales >= 10000 THEN 'Mid-Range'
	ELSE 'Low-Performers'
END Revenue_performing,
total_quantity,
total_customers,
-- average order revenue (AOR)
CASE 
	WHEN total_orders = 0 THEN 0
	ELSE total_sales / total_orders 
END AS avg_order_revenue,
-- average monthly revenue
CASE
	WHEN lifespan = 0 THEN total_sales
	ELSE total_sales / lifespan
END AS avg_monthly_revenue
FROM product_aggregation
