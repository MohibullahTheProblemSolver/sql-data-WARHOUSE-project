/*
=======================================
DDL Scripts: Creating Bronze Table
=======================================
Script Purpose:
This script creates tables in the  'bronze' schema, 
dropping existing table if they already exist.
Run this script in order to redefine the DDL Structure of 'bronze' table

*/

IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);
GO

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
DROP TABLE bronze.crm_prd_info

CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
);
GO

IF OBJECT_ID('crm_sales_details', 'U') IS NOT NULL
DROP TABLE crm_sales_details

CREATE TABLE crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

GO

IF OBJECT_ID('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
DROP TABLE bronze.erp_CUST_AZ12;

CREATE TABLE bronze.erp_CUST_AZ12(
	CID [varchar](50) NULL,
	BDATE [date] NULL,
	GEN varchar(20) NULL
);

GO

IF OBJECT_ID('bronze.erp_LOC_A101', 'U') IS NOT NULL
DROP TABLE bronze.erp_LOC_A101;
CREATE TABLE bronze.erp_LOC_A101(
	CID [varchar](50) NULL,
	CNTRY [varchar](50) NULL
);

GO
