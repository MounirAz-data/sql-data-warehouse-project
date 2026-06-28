/*
===============================================================================
Date Exploration
===============================================================================
Purpose:
    This script explores the date ranges and age distributions within the data.
    It helps understand the time span of available sales data and the
    demographic profile of customers based on their birthdates.
===============================================================================
*/

-- Find the date of the first and last order
-- Helps understand the full time span of available sales data
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales

-- Find the youngest and oldest customer
-- Helps understand the age range of our customer base
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers
