/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    This script tracks how key business metrics evolve over time.
    It helps identify trends, seasonal patterns, and growth or decline
    in sales, customer activity, and quantity sold across different
    time periods (yearly and monthly).
===============================================================================
*/

-- Change Over Year Analysis
-- Tracks total sales, unique customers, and quantity sold per year
SELECT
    YEAR(order_date)            AS order_year,
    SUM(sales_amount)           AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity)               AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date) ASC

-- Change Over Month Analysis
-- Provides a more granular view of trends at the monthly level
SELECT
    DATETRUNC(month, order_date)  AS order_month,
    SUM(sales_amount)             AS total_sales,
    COUNT(DISTINCT customer_key)  AS total_customers,
    SUM(quantity)                 AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date) ASC
