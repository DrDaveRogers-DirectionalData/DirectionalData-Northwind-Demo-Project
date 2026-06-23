with source as (
    select * from {{ source('northwind_raw', 'shippers') }}
),

renamed as (
    select
        ShipperID   as shipper_id,
        CompanyName as company_name,
        Phone       as phone

    from source
)

select * from renamed
