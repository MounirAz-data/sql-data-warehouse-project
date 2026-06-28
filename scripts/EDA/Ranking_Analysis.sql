/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    This script ranks customers and products based on key performance metrics
    such as revenue and order count. It identifies top performers and
    underperformers to support business decisions around product strategy
    and customer relationship management.
===============================================================================
*/

-- Which 5 products generate the highest revenue?
-- Uses ROW_NUMBER() to rank products by total revenue
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
    GROUP BY p.product_name
) t
WHERE rank_products <= 5

-- What are the 5 worst performing products in terms of sales?
-- Identifies products with the lowest revenue for review or discontinuation
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue

-- Find the top 10 customers who have generated the highest revenue
-- Helps identify VIP customers worth prioritizing for retention
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC

-- The 3 customers with the fewest orders placed
-- Highlights potentially inactive or disengaged customers
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders
