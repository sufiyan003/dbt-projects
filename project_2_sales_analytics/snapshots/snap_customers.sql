{% snapshot snap_customers %}

{{
    config(
        target_schema='PUBLIC',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

SELECT
    id AS customer_id,
    first_name,
    last_name,
    country_code,
    updated_at
FROM {{ source('raw', 'raw_customers') }}

{% endsnapshot %}