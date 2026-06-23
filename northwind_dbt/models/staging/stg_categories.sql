with source as (
    select * from {{ source('northwind_raw', 'categories') }}
),

renamed as (
    select
        CategoryID   as category_id,
        CategoryName as category_name,
        Description  as description
        -- Picture column excluded: binary blob, not needed for analytics

    from source
)

select * from renamed
