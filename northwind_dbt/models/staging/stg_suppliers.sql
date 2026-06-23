with source as (
    select * from {{ source('northwind_raw', 'suppliers') }}
),

renamed as (
    select
        SupplierID   as supplier_id,
        CompanyName  as company_name,
        ContactName  as contact_name,
        ContactTitle as contact_title,
        Address      as address,
        City         as city,
        Region       as region,
        PostalCode   as postal_code,
        Country      as country,
        Phone        as phone,
        Fax          as fax,
        HomePage     as home_page

    from source
)

select * from renamed
