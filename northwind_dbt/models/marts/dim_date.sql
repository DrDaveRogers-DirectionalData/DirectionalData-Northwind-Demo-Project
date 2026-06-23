-- Generated date spine covering the full Northwind order date range (1996-2000)
-- plus buffer. No source table needed -- built entirely from SQL date functions.

with date_spine as (
    select explode(
        sequence(to_date('1996-01-01'), to_date('2000-12-31'), interval 1 day)
    ) as calendar_date
),

final as (
    select
        cast(date_format(calendar_date, 'yyyyMMdd') as int) as date_key,  -- surrogate key: YYYYMMDD integer

        calendar_date,
        year(calendar_date)                                  as year,
        quarter(calendar_date)                               as quarter,
        month(calendar_date)                                 as month_number,
        date_format(calendar_date, 'MMMM')                  as month_name,
        date_format(calendar_date, 'MMM')                   as month_short,
        weekofyear(calendar_date)                            as week_of_year,
        dayofmonth(calendar_date)                            as day_of_month,
        dayofweek(calendar_date)                             as day_of_week,  -- 1=Sunday, 7=Saturday
        date_format(calendar_date, 'EEEE')                  as day_name,
        case when dayofweek(calendar_date) in (1, 7)
             then true else false end                        as is_weekend,
        date_format(calendar_date, 'yyyy-MM')               as year_month,
        concat('Q', quarter(calendar_date), ' ', year(calendar_date)) as year_quarter

    from date_spine
)

select * from final
