-- MetricFlow time spine model. Required by the dbt Semantic Layer.
-- Selects from dim_date to avoid maintaining a separate date spine.
select calendar_date as date_day
from {{ ref('dim_date') }}
