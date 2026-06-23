with customers as (
    select * from {{ ref('stg_customers') }}
),

final as (
    select
        md5(cast(customer_id as string)) as customer_key,  -- surrogate key

        customer_id,
        company_name,
        contact_name,
        contact_title,
        city,
        region,
        postal_code,
        country,
        phone

    from customers
)

select * from final
