/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over time 
-- and moving_avg_price
SELECT
order_date_month,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date_month) AS running_total,
avg_price,
AVG(avg_price) OVER(ORDER BY order_date_month) AS moving_avg_total
FROM(
SELECT
DATETRUNC(month, order_date) AS order_date_month,
SUM(Sales) AS total_sales,
AVG(Price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
)t

