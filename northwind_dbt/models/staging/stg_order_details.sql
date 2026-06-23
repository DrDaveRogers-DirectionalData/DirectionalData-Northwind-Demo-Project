with source as (
    select * from {{ source('northwind_raw', 'order_details') }}
),

renamed as (
    select
        OrderID                          as order_id,
        ProductID                        as product_id,
        cast(UnitPrice as decimal(10,2)) as unit_price,
        Quantity                         as quantity,
        cast(Discount  as decimal(5,4))  as discount_rate

    from source
)

select * from renamed
