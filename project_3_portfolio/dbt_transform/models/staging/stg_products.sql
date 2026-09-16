SELECT
    product_id,
    product_name,
    price,
    category
FROM {{ source('raw', 'raw_products') }}