with employees as (
    select * from {{ ref('stg_employees') }}
),

territory_summary as (
    select
        employee_id,
        count(territory_id)             as territory_count,
        collect_list(territory_description) as territory_list,
        collect_set(region_description)     as region_list

    from {{ ref('int_employee_territories') }}
    group by employee_id
),

final as (
    select
        md5(cast(e.employee_id as string)) as employee_key,  -- surrogate key

        e.employee_id,
        e.first_name,
        e.last_name,
        e.first_name || ' ' || e.last_name as full_name,
        e.job_title,
        e.title_of_courtesy,
        e.hire_date,
        e.birth_date,
        e.city,
        e.country,
        e.reports_to_employee_id,
        e.home_phone,
        coalesce(ts.territory_count, 0)    as territory_count,
        ts.territory_list,
        ts.region_list

    from employees e
    left join territory_summary ts on e.employee_id = ts.employee_id
)

select * from final
