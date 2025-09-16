/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT
MIN(order_date) AS first_order,
MAX(order_date) AS last_order_date,
DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales;

-- Find the youngest and oldest customer based on birthdate
SELECT
MIN(birth_date) AS oldest_customer,
DATEDIFF(YEAR, MIN(birth_date), GETDATE()) AS oldest_customer_age,
MAX(birth_date) AS younger_customer,
DATEDIFF(YEAR, MAX(birth_date), GETDATE()) AS younger_customer_age
FROM gold.dim_customers

