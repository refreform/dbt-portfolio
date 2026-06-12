with source as (
        select *
        from {{ source('stackoverflow', 'survey_2025') }}
    )

select cast(2025 as int) as survey_year,
       ResponseId as response_id,
       MainBranch as main_branch,
       Employment as employment,
       Country as country,
       Currency as currency,
       try_cast(CompTotal as double) as comp_total,
       cast(null as string) as comp_freq,
       try_cast(ConvertedCompYearly as double) as converted_comp_yearly,
       Age as age,
       EdLevel as ed_level,
       DevType as dev_type,
       OrgSize as org_size,
       YearsCode as years_code,
       cast(null as string) as years_code_pro,
       try_cast(WorkExp as double) as work_exp,
       RemoteWork as remote_work,
       Industry as industry
from source
