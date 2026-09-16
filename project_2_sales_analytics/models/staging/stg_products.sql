SELECT
    id AS product_id,
    product_name,
    category,
    price
FROM {{ source('raw', 'raw_products') }}