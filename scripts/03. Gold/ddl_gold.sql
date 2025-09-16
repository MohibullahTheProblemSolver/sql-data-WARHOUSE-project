/*
========================================================
DDL Script: Create Gold Views
========================================================
Script Purpose:
		This scripts create view for the Gold layer in the DataWarHouse
		The Gold layer represents final dimentions and fact table(Star Schema)

		Each view perform transformation and conbined data from Silver layer
		to produce a clean , enriched and business-ready datasets

Usage:
	-This view can be queried directly for analytics and reporting
*/


IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS
SELECT
ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
ci.cst_id AS CustomerID,
ci.cst_key AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
la.CNTRY AS country,
CASE
	WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
	ELSE COALESCE(ca.GEN, 'n/a')
END AS gender,
ci.cst_marital_status AS marital_status,
ca.BDATE AS birth_date,
ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_CUST_AZ12 ca
ON			ci.cst_key = ca.CID
LEFT JOIN silver.erp_LOC_A101 la
ON			ci.cst_key = la.CID;

GO

IF OBJECT_ID('gold.dim_products','V') IS NOT NULL
DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS prd_key,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.CAT AS Category,
	pc.SUBCAT AS Subcategory,
	pc.MAINTENANCE AS MAINTENANCE,
	pn.prd_cost AS product_cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS product_start_dt
	
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_PX_CAT_G1V2 pc
ON		pn.cat_id = pc.ID
WHERE pn.prd_end_dt IS NULL; -- FILTER ALL HISTORICAL DATA

GO

IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
DROP VIEW gold.fact_sales; 

GO

CREATE VIEW gold.fact_sales AS
SELECT 
sd.sls_ord_num AS order_number,
pr.product_key AS product_key,
cs.CustomerID AS customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS Sales,
sd.sls_quantity AS Quantity,
sd.sls_price AS Price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON		sd.sls_prd_key = pr.prd_key
LEFT JOIN gold.dim_customers cs
ON sd.sls_cust_id = cs.CustomerID;

GO
