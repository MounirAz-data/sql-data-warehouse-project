/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    This report consolidates key customer metrics and behaviors into a single
    reusable view. It serves as a foundation for customer analytics, enabling
    teams to quickly assess performance, identify high value customers, and
    understand engagement patterns.

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer level metrics:
       - total orders
       - total sales
       - total quantity purchased
       - total products
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last order)
       - average order value
       - average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact and dimension tables
---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name)  AS customer_name,
        DATEDIFF(year, c.birthdate, GETDATE())   AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
    WHERE order_date IS NOT NULL
),

customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number)                        AS total_orders,
        SUM(sales_amount)                                   AS total_sales,
        SUM(quantity)                                       AS total_quantity,
        COUNT(DISTINCT product_key)                         AS total_products,
        MAX(order_date)                                     AS last_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date))   AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

/*---------------------------------------------------------------------------
3) Final Output: Adds segmentation, age groups, and KPI calculations
---------------------------------------------------------------------------*/
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    -- Segment customers into age groups for demographic analysis
    CASE
        WHEN age < 20                   THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29      THEN '20-29'
        WHEN age BETWEEN 30 AND 39      THEN '30-39'
        WHEN age BETWEEN 40 AND 49      THEN '40-49'
        ELSE '50 and above'
    END AS age_group,
    -- Classify customers based on spending behavior and loyalty
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000  THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    last_order_date,
    -- Recency: how many months since the customer last placed an order
    DATEDIFF(month, last_order_date, GETDATE())     AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
    -- Average Order Value: how much a customer spends per order on average
    CASE
        WHEN total_orders = 0   THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,
    -- Average Monthly Spend: how much a customer spends per month on average
    CASE
        WHEN lifespan = 0   THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend
FROM customer_aggregation
