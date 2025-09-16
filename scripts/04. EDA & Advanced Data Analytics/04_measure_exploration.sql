/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(Sales) AS total_sales FROM gold.fact_sales;

-- Find how many items are sold
SELECT SUM(Quantity) AS total_sold_item FROM GOLD.fact_sales;

-- Find the average selling price
SELECT AVG(Price) AS avg_price FROM gold.fact_sales;

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales;

-- Find the total number of products
SELECT COUNT(product_key) AS total_product FROM gold.fact_sales;

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.fact_sales;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers_placed_1 FROM gold.fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS Measure_NAME ,SUM(Sales) AS Measure_VALUE FROM gold.fact_sales
UNION ALL
SELECT 'Total Sold Item' AS Measure_NAME  ,SUM(Quantity) AS Measure_VALUE  FROM GOLD.fact_sales
UNION ALL
SELECT 'Products Average Price' AS Measure_NAME , AVG(Price) AS Measure_VALUE FROM gold.fact_sales
UNION ALL
SELECT 'Total number of orders' AS Measure_NAME, COUNT(DISTINCT order_number) AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Total number of product' AS Measure_NAME , COUNT(DISTINCT product_key) AS Measure_VALUE FROM gold.fact_sales
UNION ALL
SELECT 'Total number of Customers' AS Measure_NAME , COUNT(customer_key) AS Measure_VALUE FROM gold.fact_sales
