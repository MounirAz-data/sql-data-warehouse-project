/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    This script explores the dimension tables to understand the available
    categories, segments, and attributes within the data.
    Useful for identifying unique values and validating data consistency
    before performing deeper analysis.
===============================================================================
*/

-- Explore All Countries our customers come from
SELECT DISTINCT country FROM gold.dim_customers

-- Explore All Categories and their Subcategories
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1, 2, 3
