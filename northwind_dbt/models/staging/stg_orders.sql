with source as (
    select * from {{ source('northwind_raw', 'orders') }}
),

renamed as (
    select
        -- keys
        OrderID        as order_id,
        CustomerID     as customer_id,
        EmployeeID     as employee_id,
        ShipVia        as shipper_id,

        -- dates
        cast(OrderDate    as date) as order_date,
        cast(RequiredDate as date) as required_date,
        cast(ShippedDate  as date) as shipped_date,

        -- shipping details
        cast(Freight as decimal(10, 2)) as freight_amount,
        ShipName       as ship_name,
        ShipAddress    as ship_address,
        ShipCity       as ship_city,
        ShipRegion     as ship_region,
        ShipPostalCode as ship_postal_code,
        ShipCountry    as ship_country

    from source
)

select * from renamed
