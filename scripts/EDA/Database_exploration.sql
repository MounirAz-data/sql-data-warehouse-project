/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    This script explores the structure of the database by retrieving
    metadata about tables and columns. Useful for understanding the
    available objects and their definitions before writing queries.
===============================================================================
*/

-- Explore All Objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore All Columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_dimensions'
