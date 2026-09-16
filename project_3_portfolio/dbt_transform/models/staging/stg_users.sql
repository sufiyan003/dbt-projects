SELECT
    user_id,
    email,
    username,
    first_name,
    last_name
FROM {{ source('raw', 'raw_users') }}