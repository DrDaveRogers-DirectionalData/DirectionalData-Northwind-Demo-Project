with source as (
    select * from {{ source('northwind_raw', 'employees') }}
),

renamed as (
    select
        EmployeeID                   as employee_id,
        LastName                     as last_name,
        FirstName                    as first_name,
        Title                        as job_title,
        TitleOfCourtesy              as title_of_courtesy,
        cast(BirthDate as date)      as birth_date,
        cast(HireDate  as date)      as hire_date,
        Address                      as address,
        City                         as city,
        Region                       as region,
        PostalCode                   as postal_code,
        Country                      as country,
        HomePhone                    as home_phone,
        Extension                    as phone_extension,
        Notes                        as notes,
        ReportsTo                    as reports_to_employee_id,
        PhotoPath                    as photo_path
        -- Photo (binary blob) excluded

    from source
)

select * from renamed
