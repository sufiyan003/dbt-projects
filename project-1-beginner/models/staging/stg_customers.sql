{% set filter_country = false %}

SELECT
    id AS customer_id,
    first_name,
    last_name,
    email,
    country_code
FROM {{ source('raw', 'raw_customers') }}

{% if filter_country %}
WHERE country_code = 'PK'
{% endif %}
