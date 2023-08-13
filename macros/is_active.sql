{% macro is_active(left_alias, right_alias, curr_date, start_date, end_date, should_handle_nulls=False) %}
    {%- set active_condition = left_alias + '.' + curr_date + ' >= ' + right_alias + '.' + start_date -%}
    {%- if should_handle_nulls -%}
        {%- set active_condition = active_condition + ' AND (' + left_alias + '.' + curr_date + ' < ' + right_alias + '.' + end_date + ' OR ' + right_alias + '.' + end_date + ' IS NULL)' -%}
    {%- else -%}
        {%- set active_condition = active_condition + ' AND ' + left_alias + '.' + curr_date + ' < ' + right_alias + '.' + end_date -%}
    {%- endif -%}
    {{ active_condition }}
{% endmacro %}
