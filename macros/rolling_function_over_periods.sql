{% macro rolling_function_over_periods(column_name, func='avg', partition_by='', order_by='', periods=6) %}
    {%- set window_def = '' -%}
    {%- if periods | lower() == 'unbounded' -%}
            {%- set window_def = '' -%}
    {%- else -%}
        {%- if order_by == '' -%}
            {{ exceptions.raise_compiler_error("Cannot build a BOUNDED WINDOW without specifying an ORDER BY clause") }}
        {%- endif -%}
        {%- set window_def = 'ROWS BETWEEN ' ~ periods ~ ' PRECEDING AND CURRENT ROW' -%}
    {%- endif -%}

    {{ func }}( {{ column_name }} ) OVER (
        {%- if partition_by %} PARTITION BY {{ partition_by }}{%- endif -%}
        {%- if partition_by and order_by %} {% endif -%}
        {%- if order_by %} ORDER BY {{ order_by }} {% endif -%}
        {%- if window_def %} {{ window_def }} {% endif -%}
    ) AS {{ func }}_{%- if periods == 'unbounded' %}unbounded{% else %}{{ periods + 1 }}{% endif %}_periods_{{ column_name }}
{%- endmacro -%}
