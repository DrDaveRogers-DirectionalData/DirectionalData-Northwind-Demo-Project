with products as (
    select * from {{ ref('stg_products') }}
),

categories as (
    select * from {{ ref('stg_categories') }}
),

suppliers as (
    select * from {{ ref('stg_suppliers') }}
),

final as (
    select
        md5(cast(p.product_id as string)) as product_key,  -- surrogate key

        p.product_id,
        p.product_name,
        p.category_id,
        c.category_name,
        p.supplier_id,
        s.company_name as supplier_name,
        s.country      as supplier_country,
        p.quantity_per_unit,
        p.unit_price,
        p.units_in_stock,
        p.units_on_order,
        p.reorder_level,
        p.is_discontinued

    from products p
    left join categories c on p.category_id = c.category_id
    left join suppliers  s on p.supplier_id = s.supplier_id
)

select * from final
