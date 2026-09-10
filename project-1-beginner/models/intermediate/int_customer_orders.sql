{{ config(materialized='view') }}

SELECT
    c.customer_id,
    c.full_name,
    c.email,
    COUNT(o.order_id) AS total_orders,
    SUM(o.amount) AS total_spent
FROM {{ ref('dim_customers') }} c
LEFT JOIN {{ ref('fct_orders') }} o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name, c.email