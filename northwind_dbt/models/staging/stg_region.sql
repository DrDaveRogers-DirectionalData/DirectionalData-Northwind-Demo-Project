with source as (
    select * from {{ source('northwind_raw', 'region') }}
),

renamed as (
    select
        RegionID          as region_id,
        RegionDescription as region_description

    from source
)

select * from renamed
