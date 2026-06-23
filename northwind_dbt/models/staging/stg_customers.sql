with source as (
    select * from {{ source('northwind_raw', 'customers') }}
),

renamed as (
    select
        CustomerID   as customer_id,
        CompanyName  as company_name,
        ContactName  as contact_name,
        ContactTitle as contact_title,
        Address      as address,
        City         as city,
        Region       as region,
        PostalCode   as postal_code,
        Country      as country,
        Phone        as phone,
        Fax          as fax

    from source
)

select * from renamed
