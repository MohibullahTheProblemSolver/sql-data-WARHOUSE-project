/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
SELECT
YEAR(order_date) AS order_date_year,
MONTH(order_date) AS order_date_month,
SUM(Sales) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customer,
SUM(Quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_date_year, order_date_month

-- DATETRUNC()

SELECT
DATETRUNC(month, order_date) AS order_date_month ,
SUM(Sales) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customer,
SUM(Quantity) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)


-- FORMAT()

SELECT
FORMAT(order_date, 'yyy-MMM') AS order_date_month ,
SUM(Sales) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customer,
SUM(Quantity) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyy-MMM')
ORDER BY FORMAT(order_date, 'yyy-MMM')

