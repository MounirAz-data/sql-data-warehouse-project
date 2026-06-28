/*
===============================================================================
Part to Whole Analysis
===============================================================================
Purpose:
    This script evaluates the contribution of each product category
    to the overall total sales. It helps identify which categories
    drive the most revenue and how the business is distributed across
    different product lines.
    Useful for strategic decisions around resource allocation,
    marketing focus, and portfolio management.
===============================================================================
*/

-- Which categories contribute the most to overall sales?
-- Calculates each category's share of total revenue as a percentage
WITH category_sales AS (
    SELECT
        category,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
    GROUP BY category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER ()                                                    AS overall_sales,
    CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC
