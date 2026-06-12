# Stack Overflow Developer Compensation (dbt + DuckDB)

Models five years of the Stack Overflow Developer Survey (2021-2025) into a US
compensation mart. This code reconciles the survey schemas, which change every year,
and adjusts pay for inflation (final mart is in 2025 dollars).

## The problem

The five annual files don't form a clean panel:

- Columns are added, dropped, and renamed; the column count grows year over year.
- USD inflates over time, causing salary comparison between years is impacted

## Architecture

```
raw CSVs   ->  staging  ->  intermediate  --+
                                            +-->  mart
CPI-U seed ---------------------------------+
```

- **Sources**: one raw CSV per year, gitignored in `data/raw/` (too large to
  commit). Download: https://survey.stackoverflow.co/
- **Staging**: one model per year, projected to a canonical schema, typed, and
  null-filled for columns absent that year so all five union cleanly. Schema drift
  is dealt with here.
- **Intermediate**: unions the years, filters to US.
- **Seeds**: CPI-U annual averages (FRED), committed as a static CSV and joined in the mart. 
October 2025 data is missing due to government shutdown, and will not be backfilled, 
so used only the 11 available months to compute the CPI average in 2025. Direct download 
available here, but not necissary as the csv is in the repo
- **Mart**: US compensation, CPI-deflated to 2025 dollars.

## Key decisions

- **Comp base is `ConvertedCompYearly`** (Stack Overflow's pre-converted annual USD),
  not a rebuild from raw `CompTotal`, which would reopen the 2021/2022 annualization
  seam for no accuracy gain.
- **Inflation**: CPI-U annual averages (FRED), deflated to constant dollars.
- **US-only scope**: US salaries are USD-native, so figures are exact with no
  currency or purchasing-power confound. A global cut would inherit the per-year
  exchange-rate drift baked into the source, so it's deliberately out of scope.

## Stack

dbt-duckdb, DuckDB, Python 3.12, uv

## Running it

```
uv sync
cd analytics
dbt deps
dbt build
```

Warehouse builds to `analytics/dev.duckdb`.

## Status

- Built and tested: Staging, CPI seed
- In progress:intermediate, US mart
