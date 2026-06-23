with orders as (
    select * from {{ ref('stg_orders') }}
),

order_details as (
    select * from {{ ref('stg_order_details') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

categories as (
    select * from {{ ref('stg_categories') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

employees as (
    select * from {{ ref('stg_employees') }}
),

shippers as (
    select * from {{ ref('stg_shippers') }}
),

joined as (
    select
        -- keys
        od.order_id,
        od.product_id,
        o.customer_id,
        o.employee_id,
        o.shipper_id,
        p.category_id,
        p.supplier_id,

        -- dates
        o.order_date,
        o.required_date,
        o.shipped_date,

        -- line item measures
        od.unit_price,
        od.quantity,
        od.discount_rate,
        round(od.unit_price * od.quantity, 2)                          as gross_revenue,
        round(od.unit_price * od.quantity * od.discount_rate, 2)       as discount_amount,
        round(od.unit_price * od.quantity * (1 - od.discount_rate), 2) as net_revenue,

        -- order-level measure (repeated across line items in same order)
        o.freight_amount,

        -- fulfillment flags and durations
        case when o.shipped_date is not null then true else false end        as is_shipped,
        case when o.shipped_date > o.required_date then true else false end  as is_late,
        case when o.shipped_date is not null
             then datediff(o.shipped_date, o.order_date) end                as days_to_ship,
        case when o.shipped_date > o.required_date
             then datediff(o.shipped_date, o.required_date) end             as days_late,

        -- product attributes
        p.product_name,
        p.is_discontinued,

        -- category
        c.category_name,

        -- customer
        cu.company_name  as customer_name,
        cu.city          as customer_city,
        cu.country       as customer_country,

        -- employee
        e.first_name || ' ' || e.last_name as employee_full_name,

        -- shipper
        s.company_name as shipper_name,

        -- ship destination
        o.ship_city,
        o.ship_country

    from order_details od
    inner join orders    o  on od.order_id   = o.order_id
    inner join products  p  on od.product_id = p.product_id
    inner join categories c on p.category_id = c.category_id
    left  join customers cu on o.customer_id = cu.customer_id
    left  join employees e  on o.employee_id = e.employee_id
    left  join shippers  s  on o.shipper_id  = s.shipper_id
)

select * from joined
