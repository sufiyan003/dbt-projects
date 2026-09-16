SELECT
    cart_id,
    user_id,
    cart_date,
    product_id,
    quantity
FROM {{ source('raw', 'raw_cart_items') }}