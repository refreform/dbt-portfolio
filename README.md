# Stack Overflow Developer Compensation (dbt + DuckDB)

Models five years of the Stack Overflow Developer Survey (2021-2025) into a US
compensation mart. This code reconciles the survey schemas, which change every year,
and adjusts pay for inflation (final mart has a column in 2025 dollars).

## The problem

The five annual files don't form a clean panel:
- Columns are added, dropped, and renamed year over year.
- Comparing nominal salaries across years does not account for inflation.

## Architecture

```
raw CSVs (gitignored)  ->  staging  ->  mart
                                          ^
CPI-U seed (committed) ->  intermediate --+
```

- **Sources**: one raw CSV per year, gitignored in `data/raw/` (files are 50-200 MB).
  Download from https://survey.stackoverflow.co/
- **Staging**: one model per year. Projects the raw columns to a shared 
  schema, casts types, and null-fills columns absent in that year so all five union
  cleanly. Schema drift is handled here.
- **Intermediate**: `int_stackoverflow__cpi_u` -- computes annual CPI-U averages from
  the monthly FRED seed data.
- **Seeds**: Monthly CPI-U observations from FRED, committed as a static CSV. 
  Note: October 2025 is missing due to a government shutdown and will not
  be back-filled. The 2025 annual average uses the 11 available months.
- **Mart**: `stackoverflow__survey` -- unions all five years, filters to US respondents,
  and joins CPI to produce `adjusted_comp_yearly_2025` (constant 2025 USD). The 2025
  cohort is passed through un-adjusted since it is already in the base year.
  
## Key decisions

- **Inflation index**: CPI-U annual averages (FRED)
- **US-only scope**: US respondents report in USD natively, eliminating currency 
  and purchasing-power confounds that would complicate a global cut. However, the 
  underlying data is still stored in the marts so a further project could build 
  on this one if desired

## Stack

dbt-duckdb, DuckDB, Python 3.12, uv

## Running it

```
uv sync
cd analytics
dbt build
```

Warehouse builds to `analytics/dev.duckdb`.

## Notes
The 2025 survey was smaller, and that decision was made by Stackoverflow. Lower 
totals for 2025 are correct, not a filtering/ data cleanliness issue

## Status

Project is fully complete
