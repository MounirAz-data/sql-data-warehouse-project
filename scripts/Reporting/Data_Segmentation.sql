/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    This script segments customers into meaningful groups based on their
    spending behavior and relationship longevity with the business.
    Understanding customer segments helps drive targeted marketing strategies,
    retention efforts, and personalized customer experiences.

    Segments defined as:
    - VIP      : Customers with 12+ months history and spending above 5,000
    - Regular  : Customers with 12+ months history and spending of 5,000 or less
    - New      : Customers with less than 12 months of purchase history

    Output shows the total number of customers in each segment.
===============================================================================
*/

-- Segment customers based on lifespan and total spending
-- Then count how many customers fall into each segment
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount)                                    AS total_spending,
        MIN(order_date)                                        AS first_order,
        MAX(order_date)                                        AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date))      AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000  THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) t
GROUP BY customer_segment
ORDER BY total_customers DESC
