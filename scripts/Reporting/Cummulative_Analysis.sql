/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    This script calculates running totals to track cumulative performance
    over time. It helps understand how sales accumulate month over month
    within each year, revealing growth patterns and overall business momentum.
===============================================================================
*/

-- Calculate total sales per month and the running total within each year
-- Running total resets at the start of each new year (PARTITION BY YEAR)
SELECT *,
    SUM(total_monthly_sales) OVER (
        PARTITION BY YEAR(monthly_date) 
        ORDER BY monthly_date
    ) AS running_total_sales
FROM (
    SELECT
        DATETRUNC(month, order_date) AS monthly_date,
        SUM(sales_amount)            AS total_monthly_sales
    FROM gold.fact_sales
    WHERE DATETRUNC(month, order_date) IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) t
