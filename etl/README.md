# ETL Pipeline — SQL Server Integration Services (SSIS)

This component converts the **unstructured image dataset** into **structured
relational data**. Folder names such as `Tomato___Late_blight` encode the crop
and disease; a Python step extracts that metadata into a CSV, and this SSIS
package transforms and loads it into SQL Server.

## Contents

| File | Purpose |
|------|---------|
| `DATA604_TRY.ispac` | Deployable SSIS project (open in Visual Studio / SSDT). |
| `package/Package.dtsx` | The extracted, human-readable package definition. |
| `package/Project.params` | Project-level parameters (none defined). |

## Data flow

```
Flat File Source            checkkt.csv  (plant_type, disease_name,
      │                                   class_name, disease_severity)
      ▼
Data Conversion             cast text columns to Unicode strings
      │
      ▼
Derived Column              add 4 computed columns:
      │                       • NUmb Label          severity as int 0..3
      │                       • Plant_cat            Root / Grain / Fruit / ...
      │                       • Severity_risk_level  Low / High
      │                       • is_fruit_crop        1 / 0
      ▼
Conditional Split           route rows by plant_type
      │
      ├── plant_type == "Peach"        ─▶ OLE DB Destination → dbo.Peach
      ├── plant_type == "Tomato"       ─▶ OLE DB Destination → dbo.Tomato
      ├── plant_type == "Potato"       ─▶ OLE DB Destination → dbo.Potato
      ├── plant_type == "Corn (maize)" ─▶ OLE DB Destination → dbo.Corn
      └── default                      ─▶ OLE DB Destination → dbo.Other_Plants
```

## Derived column logic

- **NUmb Label** — `Healthy → 0, Mild → 1, Moderate → 2, Severe → 3`
- **Plant_cat** — categorises the crop (`Potato → Root`, `Corn → Grain`,
  `Raspberry → Fruit`, `Squash → Vegetable`, …)
- **Severity_risk_level** — `Healthy` or `Mild → "Low"`, otherwise `"High"`
- **is_fruit_crop** — `1` for Apple, Peach, Tomato, Strawberry, Raspberry,
  Grape, … ; `0` otherwise

## Running the package

1. Open `DATA604_TRY.ispac` in **Visual Studio** with the
   *SQL Server Integration Services Projects* extension, or deploy it to the
   SSIS Catalog on a SQL Server instance.
2. Update the **Flat File Connection Manager** to point at your exported CSV
   (the original path was a local `checkkt.csv`).
3. Update the **OLE DB Connection Manager** to point at your SQL Server and the
   `ETL_VENU` database (create it first with [`../database/schema.sql`](../database/schema.sql)).
4. Execute the package — each plant table is populated by its Conditional
   Split output.

> The source CSV is generated from the image dataset; see the
> Transformation Phase described in the [project report](../docs).
