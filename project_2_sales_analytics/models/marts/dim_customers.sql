{{ config(materialized='table') }}

SELECT
    customer_id,
    first_name || ' ' || last_name AS full_name,
    email,
    country_code
FROM {{ ref('stg_customers') }}