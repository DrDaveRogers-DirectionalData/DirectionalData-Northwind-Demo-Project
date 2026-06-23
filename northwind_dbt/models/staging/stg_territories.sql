with source as (
    select * from {{ source('northwind_raw', 'territories') }}
),

renamed as (
    select
        TerritoryID          as territory_id,
        TerritoryDescription as territory_description,
        RegionID             as region_id

    from source
)

select * from renamed
