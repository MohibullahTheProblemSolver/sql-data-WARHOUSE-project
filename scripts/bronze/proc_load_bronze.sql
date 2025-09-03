/*
===================================================
Stored Procedure : Load Bronze Layer
===================================================
Script Purpose:
	This stored procedure loads data into 'bronze' schemas from external csv file.
	It performs the following actions:
	- Truncates the bronze tables before loading data.
	- Uses the 'BULK INSERT' to load data from  csv file to bronze tables

Parameter:
	None.
	This stored procedure does not accept any parameter or return any value

Usage example:
   EXEC bronze.load_bronze;
===================================================
*/

CREATE OR ALTER   PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
   BEGIN TRY
	PRINT '=====================================';
	PRINT 'Loading bronze layer';
	PRINT '=====================================';

	PRINT'----------------------------';
	PRINT'Loading CRM Table';
	PRINT'----------------------------';
	SET @batch_start_time = GETDATE();
	SET @start_time = GETDATE();
	PRINT'>>>>Truncating Table: bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info

	PRINT'>>>>Inserting Table: bronze.crm_cust_info';
	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\MD. MOHIBULLAH\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT 'Load duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
	PRINT '>>----------';

	SET @start_time = GETDATE();
	PRINT'>>>>Truncating Table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info

	PRINT'>>>>Inserting Table: bronze.crm_prd_info'
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Users\MD. MOHIBULLAH\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE()
	PRINT'Load duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
	PRINT '>>----------';

	SET @start_time = GETDATE();
	PRINT'>>>>Truncating Table: bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details

	PRINT'>>>>Inserting Table: bronze.crm_sales_details';
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Users\MD. MOHIBULLAH\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT'load duration:' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds'
	PRINT '>>----------';

PRINT'----------------------------';
PRINT'Loading ERP Table';
PRINT'----------------------------';

	SET @start_time = GETDATE();
	PRINT'>>>>Truncating Table: bronze.erp_CUST_AZ12';
	TRUNCATE TABLE bronze.erp_CUST_AZ12

	PRINT'>>>>Inserting Table: bronze.erp_CUST_AZ12';
	BULK INSERT bronze.erp_CUST_AZ12
	FROM 'C:\Users\MD. MOHIBULLAH\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE()
	PRINT'Loading duaration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
	PRINT '>>----------';

	SET @start_time = GETDATE();
	PRINT'>>>>Truncating Table: bronze.erp_LOC_A101';
	TRUNCATE TABLE bronze.erp_LOC_A101

	PRINT'>>>>Inserting Table: bronze.erp_LOC_A101';
	BULK INSERT bronze.erp_LOC_A101
	FROM 'C:\Users\MD. MOHIBULLAH\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT'Loading duration: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds'
	PRINT '>>----------';

	SET @start_time = GETDATE();
	PRINT'>>>>Truncating Table: bronze.erp_PX_CAT_G1V2';
	TRUNCATE TABLE bronze.erp_PX_CAT_G1V2
	
	PRINT'>>>>Inserting Table: bronze.erp_PX_CAT_G1V2';
	BULK INSERT bronze.erp_PX_CAT_G1V2
	FROM 'C:\Users\MD. MOHIBULLAH\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT'loading duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
	PRINT '>>----------';

	SET @batch_end_time = GETDATE()
	PRINT '=====================================';
	PRINT'Full load of bronze completed!'
	PRINT'TOTAL LOAD Duration: ' + CAST(DATEDIFF(second,@batch_start_time, @batch_start_time) AS NVARCHAR) + ' Seconds'
	PRINT '=====================================';
   END TRY
   BEGIN CATCH
   PRINT'============================='
   PRINT'ERROR OCCURED DURING BRONZE LAYER'
   PRINT'Error Message' + ERROR_MESSAGE();
   PRINT'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
   PRINT'Error State' + CAST(ERROR_STATE() AS NVARCHAR);
   PRINT'============================='
   END CATCH

END
