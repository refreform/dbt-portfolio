with cpi as (
        select *
        from {{ ref('int_stackoverflow__cpi_u') }}
    ),

    cpi_2025 as (
        select cpi_year,
               cpi_yearly_avg as cpi_2025
        from cpi
        where cpi_year = 2025
    ),
    
    survey_2021 as (
        select survey_2021.*,
            survey_2021.converted_comp_yearly * (cpi_2025.cpi_2025 / cpi.cpi_yearly_avg) as adjusted_comp_yearly_2025
        from {{ ref('stg_stackoverflow__survey_2021') }} as survey_2021
        left join cpi 
            on survey_2021.survey_year = cpi.cpi_year
        left join cpi_2025
            on 1 = 1
        where country = 'United States of America'
    ),

    survey_2022 as (
        select survey_2022.*,
            survey_2022.converted_comp_yearly * (cpi_2025.cpi_2025 / cpi.cpi_yearly_avg) as adjusted_comp_yearly_2025
        from {{ ref('stg_stackoverflow__survey_2022') }} as survey_2022
        left join cpi 
            on survey_2022.survey_year = cpi.cpi_year
        left join cpi_2025
            on 1 = 1
        where country = 'United States of America'
    ),

    survey_2023 as (
        select survey_2023.*,
            survey_2023.converted_comp_yearly * (cpi_2025.cpi_2025 / cpi.cpi_yearly_avg) as adjusted_comp_yearly_2025
        from {{ ref('stg_stackoverflow__survey_2023') }} as survey_2023
        left join cpi 
            on survey_2023.survey_year = cpi.cpi_year
        left join cpi_2025
            on 1 = 1
        where country = 'United States of America'
    ),

    survey_2024 as (
        select survey_2024.*,
            survey_2024.converted_comp_yearly * (cpi_2025.cpi_2025 / cpi.cpi_yearly_avg) as adjusted_comp_yearly_2025
        from {{ ref('stg_stackoverflow__survey_2024') }} as survey_2024
        left join cpi 
            on survey_2024.survey_year = cpi.cpi_year
        left join cpi_2025
            on 1 = 1
        where country = 'United States of America'
    ),

    survey_2025 as (
        select survey_2025.*,
            survey_2025.converted_comp_yearly as adjusted_comp_yearly_2025
        from {{ ref('stg_stackoverflow__survey_2025') }} as survey_2025
        where country = 'United States of America'
    ),

    all_surveys as (
        select *
        from survey_2021

        union all

        select *
        from survey_2022

        union all

        select *
        from survey_2023

        union all

        select *
        from survey_2024

        union all

        select *
        from survey_2025
    )

select concat(survey_year,'_',response_id) as unique_id,
    survey_year,
    main_branch,
    employment,
    country,
    currency,
    comp_total,
    comp_freq,
    converted_comp_yearly,
    adjusted_comp_yearly_2025,
    age,
    ed_level,
    dev_type,
    org_size,
    years_code,
    years_code_pro,
    work_exp,
    remote_work,
    industry
from all_surveys
