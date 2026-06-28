/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script runs quality checks to verify the integrity, consistency,
    and accuracy of the Gold Layer. These checks confirm:
    - Surrogate keys in dimension tables are unique with no duplicates.
    - Fact and dimension tables maintain proper referential integrity.
    - Data model relationships are valid and ready for analytical use.

Usage Notes:
    - Execute these checks after loading data into the Silver Layer.
    - Any discrepancies found must be investigated and resolved before use.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
