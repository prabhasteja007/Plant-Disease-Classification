/* ============================================================================
   Crop Disease Detection — Analytical queries
   ----------------------------------------------------------------------------
   These queries aggregate the per-plant tables to produce the metrics shown
   in the Power BI dashboard (../powerbi). They union the five plant tables
   into a single logical view first.
   ============================================================================ */

USE ETL_VENU;
GO

/* ----------------------------------------------------------------------------
   A unified view across all plant tables — convenient for cross-crop analysis.
   ---------------------------------------------------------------------------- */
CREATE OR ALTER VIEW dbo.vw_AllPlants AS
    SELECT *, 'Tomato'       AS source_table FROM dbo.Tomato
    UNION ALL
    SELECT *, 'Peach'        AS source_table FROM dbo.Peach
    UNION ALL
    SELECT *, 'Potato'       AS source_table FROM dbo.Potato
    UNION ALL
    SELECT *, 'Corn'         AS source_table FROM dbo.Corn
    UNION ALL
    SELECT *, 'Other_Plants' AS source_table FROM dbo.Other_Plants;
GO

/* 1. Disease distribution by crop type --------------------------------------
   How many image records exist per plant / disease combination. */
SELECT plant_type,
       disease_name,
       COUNT(*) AS sample_count
FROM   dbo.vw_AllPlants
GROUP  BY plant_type, disease_name
ORDER  BY plant_type, sample_count DESC;
GO

/* 2. Total severity score by crop -------------------------------------------
   Sum of the numeric severity label per plant type — the bar chart in
   the Power BI report ("Sum of disease_severity by plant_type"). */
SELECT plant_type,
       SUM([NUmb Label]) AS total_severity_score,
       COUNT(*)          AS sample_count
FROM   dbo.vw_AllPlants
GROUP  BY plant_type
ORDER  BY total_severity_score DESC;
GO

/* 3. Risk-level breakdown ---------------------------------------------------
   Share of Low vs High risk records per crop. */
SELECT plant_type,
       Severity_risk_level,
       COUNT(*) AS sample_count
FROM   dbo.vw_AllPlants
GROUP  BY plant_type, Severity_risk_level
ORDER  BY plant_type, Severity_risk_level;
GO

/* 4. Healthy vs diseased comparison ----------------------------------------- */
SELECT plant_type,
       SUM(CASE WHEN disease_severity = 'Healthy' THEN 1 ELSE 0 END) AS healthy_count,
       SUM(CASE WHEN disease_severity <> 'Healthy' THEN 1 ELSE 0 END) AS diseased_count
FROM   dbo.vw_AllPlants
GROUP  BY plant_type
ORDER  BY plant_type;
GO

/* 5. Fruit-crop vs non-fruit-crop disease burden ---------------------------- */
SELECT CASE WHEN is_fruit_crop = 1 THEN 'Fruit crop' ELSE 'Non-fruit crop' END AS crop_group,
       COUNT(*)          AS sample_count,
       SUM([NUmb Label]) AS total_severity_score
FROM   dbo.vw_AllPlants
GROUP  BY is_fruit_crop;
GO
