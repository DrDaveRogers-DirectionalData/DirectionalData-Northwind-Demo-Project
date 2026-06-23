with source as (
    select * from {{ source('northwind_raw', 'employee_territories') }}
),

renamed as (
    select
        EmployeeID  as employee_id,
        TerritoryID as territory_id

    from source
)

select * from renamed
