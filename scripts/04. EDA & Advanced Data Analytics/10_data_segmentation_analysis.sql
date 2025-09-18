/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/
WITH product_segmentation AS
(
SELECT 
product_key,
product_name,
product_cost,
CASE
	WHEN product_cost < 100 THEN 'below 100'
	WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
	WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
	ELSE 'Above 1000'
END cost_range
FROM gold.dim_products
)
SELECT
cost_range,
COUNT(product_key) AS total_products
FROM product_segmentation
GROUP BY cost_range;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_spending AS
(
SELECT
c.customer_key,
SUM(f.Sales) AS total_spending,
MIN(f.order_date) AS first_order,
MAX(f.order_date) AS last_order
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key
)
SELECT
customer_label,
COUNT(customer_key) AS total_customers
FROM 
(
SELECT
customer_key,
total_spending,
first_order,
last_order,
DATEDIFF(MONTH, first_order, last_order) AS lifespan,
CASE 
	WHEN total_spending > 5000 AND DATEDIFF(MONTH, first_order, last_order) >= 12 THEN 'VIP'
	WHEN total_spending <= 5000 AND DATEDIFF(MONTH, first_order, last_order) >= 12 THEN 'Regular'
	ELSE 'New customer'
END customer_label
FROM customer_spending
)t
GROUP BY customer_label
ORDER BY total_customers DESC;
