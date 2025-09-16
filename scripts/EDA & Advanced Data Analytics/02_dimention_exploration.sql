/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT
Country
FROM gold.dim_customers
ORDER BY country DESC

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT
	Category,
	Subcategory,
	product_name
FROM gold.dim_products
ORDER BY
	Category, Subcategory, product_name
