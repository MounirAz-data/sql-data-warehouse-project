/*
===============================================================================
Key Business Metrics Report
===============================================================================
Purpose:
    This script generates a high level summary of the most important
    business metrics in one consolidated view. Instead of running
    multiple separate queries, all key measures are combined using
    UNION ALL into a single clean result set with two columns:
    measure_name and measure_value.

    Metrics covered:
    - Total Sales        : Overall revenue generated
    - Total Quantity     : Total number of items sold
    - Average Price      : Average selling price per item
    - Total Orders       : Number of unique orders placed
    - Total Products     : Number of products available
    - Total Customers    : Total number of registered customers
===============================================================================
*/

-- Generate a Report that shows all key metrics of the business
-- Each SELECT returns one metric, UNION ALL stacks them into one result set
SELECT 'Total Sales'         AS measure_name, SUM(sales_amount)          AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity',                       SUM(quantity)              FROM gold.fact_sales
UNION ALL
SELECT 'Average Price',                        AVG(price)                 FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders',                     COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products',                   COUNT(product_name)        FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers',                  COUNT(customer_key)        FROM gold.dim_customers
