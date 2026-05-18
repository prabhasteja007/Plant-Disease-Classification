# Power BI Dashboard

Interactive dashboards that turn the structured data in the `ETL_VENU`
database into visual insights on disease distribution and severity.

## Contents

| File | Purpose |
|------|---------|
| `project604_vis.pbix` | Power BI report — open with Power BI Desktop. |

## Dashboard pages

The report visualises the metadata loaded by the [ETL pipeline](../etl):

- **Disease distribution by crop** — sample counts per plant / disease,
  highlighting high-risk crops (Tomato and Corn show the most diseased samples).
- **Severity analysis** — total severity score aggregated by `plant_type`
  (`Sum of disease_severity by plant_type`).
- **Pie chart** — each crop's share of the total disease burden.
- **Healthy vs diseased comparison** across crops.

These visuals are backed by the aggregations in
[`../database/queries/analysis_queries.sql`](../database/queries/analysis_queries.sql).

## Opening the report

1. Install [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (free).
2. Open `project604_vis.pbix`.
3. If prompted, update the data source credentials to point at your SQL Server
   instance hosting the `ETL_VENU` database, then **Refresh**.

> Without a live connection to `ETL_VENU`, the report still opens and displays
> the last cached data saved with the file.
