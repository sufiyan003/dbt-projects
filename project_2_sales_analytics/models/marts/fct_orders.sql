{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
) }}

SELECT
    o.order_id,
    o.customer_id,
    o.product_id,
    o.order_date,
    o.quantity,
    p.price,
    o.quantity * p.price AS total_amount,
    o.updated_at
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_products') }} p
    ON o.product_id = p.product_id

{% if is_incremental() %}
WHERE o.updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}