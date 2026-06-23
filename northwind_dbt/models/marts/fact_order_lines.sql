with order_lines as (
    select * from {{ ref('int_order_lines_enriched') }}
),

dim_customers as (
    select customer_key, customer_id from {{ ref('dim_customers') }}
),

dim_products as (
    select product_key, product_id from {{ ref('dim_products') }}
),

dim_employees as (
    select employee_key, employee_id from {{ ref('dim_employees') }}
),

final as (
    select
        -- surrogate keys (FK to dimension tables)
        cu.customer_key,
        p.product_key,
        e.employee_key,
        cast(date_format(ol.order_date,   'yyyyMMdd') as int)  as order_date_key,
        cast(date_format(ol.shipped_date, 'yyyyMMdd') as int)  as shipped_date_key,

        -- natural keys (kept for convenience and readability)
        ol.order_id,
        ol.product_id,
        ol.customer_id,
        ol.employee_id,
        ol.shipper_id,
        ol.category_id,

        -- dates
        ol.order_date,
        ol.required_date,
        ol.shipped_date,

        -- measures
        ol.quantity,
        ol.unit_price,
        ol.discount_rate,
        ol.gross_revenue,
        ol.discount_amount,
        ol.net_revenue,
        ol.freight_amount,

        -- fulfillment flags and durations
        ol.is_shipped,
        ol.is_late,
        ol.days_to_ship,
        ol.days_late,

        -- degenerate dimensions (descriptive attrs with no separate dim table)
        ol.shipper_name,
        ol.ship_city,
        ol.ship_country,
        ol.category_name,
        ol.product_name,
        ol.customer_name,
        ol.customer_country,
        ol.employee_full_name

    from order_lines ol
    left join dim_customers cu on ol.customer_id = cu.customer_id
    left join dim_products  p  on ol.product_id  = p.product_id
    left join dim_employees e  on ol.employee_id = e.employee_id
)

select * from final
