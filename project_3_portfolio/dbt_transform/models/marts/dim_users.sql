{{ config(materialized='table') }}

SELECT
    user_id,
    first_name || ' ' || last_name AS full_name,
    email,
    username
FROM {{ ref('stg_users') }}