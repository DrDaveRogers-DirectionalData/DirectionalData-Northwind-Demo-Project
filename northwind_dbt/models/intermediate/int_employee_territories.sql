with employee_territories as (
    select * from {{ ref('stg_employee_territories') }}
),

territories as (
    select * from {{ ref('stg_territories') }}
),

region as (
    select * from {{ ref('stg_region') }}
),

joined as (
    select
        et.employee_id,
        et.territory_id,
        t.territory_description,
        t.region_id,
        r.region_description

    from employee_territories et
    inner join territories t on et.territory_id = t.territory_id
    inner join region      r on t.region_id     = r.region_id
)

select * from joined
