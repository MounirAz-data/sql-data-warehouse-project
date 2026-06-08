/*
================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
================================================================================
Script Purpose:
    This stored procedure loads raw data into the 'bronze' schema from
    external CSV source files (CRM and ERP systems).
    It performs the following actions:
    - Truncates all bronze tables before loading to ensure fresh data.
    - Uses BULK INSERT to load data from CSV files into bronze tables.
    - Tracks and prints load duration for each table and total batch.
    - Handles errors gracefully using TRY/CATCH block.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Bronze.load_bronze;
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '=====================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=====================================================';

		PRINT '-----------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-----------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_cust_info';
		TRUNCATE TABLE Bronze.crm_cust_info;

		PRINT '>> Inserting Data Into: Bronze.crm_cust_info';
		BULK INSERT Bronze.crm_cust_info
		FROM 'C:\Users\CeloSia\Desktop\Data Enginering\Structured Query Language\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_prd_info';
		TRUNCATE TABLE Bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: Bronze.crm_prd_info';
		BULK INSERT Bronze.crm_prd_info
		FROM 'C:\Users\CeloSia\Desktop\Data Enginering\Structured Query Language\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_sales_details';
		TRUNCATE TABLE Bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: Bronze.crm_sales_details';
		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\Users\CeloSia\Desktop\Data Enginering\Structured Query Language\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------';

		PRINT '-----------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-----------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_cust_az12';
		TRUNCATE TABLE Bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: Bronze.erp_cust_az12';
		BULK INSERT Bronze.erp_cust_az12
		FROM 'C:\Users\CeloSia\Desktop\Data Enginering\Structured Query Language\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_loc_a101';
		TRUNCATE TABLE Bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: Bronze.erp_loc_a101';
		BULK INSERT Bronze.erp_loc_a101
		FROM 'C:\Users\CeloSia\Desktop\Data Enginering\Structured Query Language\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data Into: Bronze.erp_px_cat_g1v2';
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'C:\Users\CeloSia\Desktop\Data Enginering\Structured Query Language\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' s';
		PRINT '-------------------';

		SET @batch_end_time = GETDATE();
		PRINT '=======================================================';
		PRINT '>> Total Load Duration : ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' s';
		PRINT '=======================================================';

	END TRY
	BEGIN CATCH
		PRINT '=====================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message : ' + ERROR_MESSAGE();
		PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State   : ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=====================================================';
	END CATCH

END
GO
