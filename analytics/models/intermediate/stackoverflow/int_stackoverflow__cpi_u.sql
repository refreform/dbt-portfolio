with cpi_u_raw as (
        select *
        from {{ ref('cpi_u') }}   
    ),

    cpi_u_renamed as (
        select observation_date as cpi_date,
               CPIAUCNS as cpi_value
        from cpi_u_raw
    )

select extract(year from cpi_date) as cpi_year,
       avg(cpi_value) as cpi_yearly_avg
from cpi_u_renamed
group by extract(year from cpi_date)