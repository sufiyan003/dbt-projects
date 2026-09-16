{{ config(materialized='table') }}

SELECT
    c.cart_id,
    c.user_id,
    c.cart_date,
    c.product_id,
    c.quantity,
    p.price,
    c.quantity * p.price AS line_total
FROM {{ ref('stg_cart_items') }} c
LEFT JOIN {{ ref('dim_products') }} p
    ON c.product_id = p.product_id