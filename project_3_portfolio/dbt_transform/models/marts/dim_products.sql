{{ config(materialized='table') }}

SELECT
    product_id,
    product_name,
    category,
    price,
    CASE 
        WHEN price < 20 THEN 'Budget'
        WHEN price BETWEEN 20 AND 100 THEN 'Mid-range'
        ELSE 'Premium'
    END AS price_tier
FROM {{ ref('stg_products') }}