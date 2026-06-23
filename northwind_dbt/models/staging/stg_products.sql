with source as (
    select * from {{ source('northwind_raw', 'products') }}
),

renamed as (
    select
        ProductID                         as product_id,
        ProductName                       as product_name,
        SupplierID                        as supplier_id,
        CategoryID                        as category_id,
        QuantityPerUnit                   as quantity_per_unit,
        cast(UnitPrice as decimal(10, 2)) as unit_price,
        UnitsInStock                      as units_in_stock,
        UnitsOnOrder                      as units_on_order,
        ReorderLevel                      as reorder_level,
        cast(Discontinued as boolean)     as is_discontinued

    from source
)

select * from renamed
