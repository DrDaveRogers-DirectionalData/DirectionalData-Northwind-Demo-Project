-- Point-in-time snapshot of product inventory as loaded from the source system.
-- One row per product. Used for COO inventory health metrics.

with products as (
    select * from {{ ref('stg_products') }}
),

dim_products as (
    select product_key, product_id from {{ ref('dim_products') }}
),

final as (
    select
        -- surrogate key (FK to dim_products)
        dp.product_key,

        -- natural key and descriptors
        pr.product_id,
        pr.product_name,
        pr.category_id,
        pr.supplier_id,
        pr.quantity_per_unit,
        pr.unit_price,

        -- inventory measures
        pr.units_in_stock,
        pr.units_on_order,
        pr.reorder_level,
        round(pr.units_in_stock * pr.unit_price, 2) as inventory_value,

        -- snapshot date (required for MetricFlow agg_time_dimension)
        current_date()                               as snapshot_date,

        -- derived inventory flags
        pr.is_discontinued,
        case when pr.units_in_stock = 0 and not pr.is_discontinued
             then true else false end                as is_out_of_stock,
        case when pr.units_in_stock <= pr.reorder_level
             then true else false end                as is_below_reorder_level

    from products pr
    left join dim_products dp on pr.product_id = dp.product_id
)

select * from final
