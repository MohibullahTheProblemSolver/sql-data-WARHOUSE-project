/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
IF OBJECT_ID('gold.customers_report', 'V') IS NOT NULL
DROP VIEW gold.customers_report;

GO

CREATE VIEW gold.customers_report AS

WITH base_query AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
(
SELECT
f.order_number,
f.product_key,
f.order_date,
f.Sales,
f.Quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ' , c.last_name) AS customer_name,
DATEDIFF(YEAR, c.birth_date, GETDATE()) AS Age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
)
, customer_segmentation AS
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
(
SELECT 
customer_key,
customer_number,
customer_name,
Age,
COUNT(order_number) AS total_order,
MAX(order_date) AS last_order,
SUM(Sales) AS total_sales,
SUM(Quantity) AS total_quantity,
COUNT(product_key) AS total_products,
DATEDIFF(MONTH, MIN(order_date), Max(order_date)) AS lifespan
FROM base_query
GROUP BY
	customer_key,
	customer_number,
	customer_name,
	Age

)
SELECT
customer_key,
customer_number,
customer_name,
Age,
CASE
	WHEN Age <20 THEN 'Under 20'
	WHEN Age BETWEEN 20 AND 29 THEN '20-29'
	WHEN Age BETWEEN 30 AND 39 THEN '30-39'
	WHEN Age BETWEEN 40 AND 49 THEN '40-49'
	WHEN Age BETWEEN 50 AND 59 THEN '50-59'
	WHEN Age BETWEEN 60 AND 70 THEN '60-70'
	ELSE 'Above 70'

END age_group,
CASE 
    WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
    WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment,
last_order,
total_order,
DATEDIFF(MONTH, last_order, GETDATE()) AS recency,
total_sales,
total_quantity,
total_products,
lifespan,
-- calculate Average order value
CASE 
	 WHEN total_sales = 0 THEN '0'
     ELSE total_sales / total_order
END AS avg_order_value,
-- calculate Avgerage monthly spend
CASE
	WHEN lifespan = 0 THEN total_sales
	ELSE total_sales / lifespan
END AS avg_monthly_spend
FROM customer_segmentation


