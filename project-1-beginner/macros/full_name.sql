{% macro full_name(first_name_col, last_name_col) %}
    {{ first_name_col }} || ' ' || {{ last_name_col }}
{% endmacro %}
