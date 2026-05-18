/* ============================================================================
   Crop Disease Detection — SQL Server schema
   Database: ETL_VENU
   ----------------------------------------------------------------------------
   The SSIS package (see ../etl) extracts a CSV of image metadata, derives
   additional columns, and routes rows by plant type into separate tables via
   a Conditional Split. All destination tables share the same column layout.
   ============================================================================ */

-- Create the database if it does not exist.
IF DB_ID('ETL_VENU') IS NULL
    CREATE DATABASE ETL_VENU;
GO

USE ETL_VENU;
GO

/* ----------------------------------------------------------------------------
   Shared column layout for every plant table.
   Columns marked "Copy of ..." are produced by the SSIS Data Conversion step;
   the remaining derived columns come from the Derived Column transformation.
   ---------------------------------------------------------------------------- */

-- Reusable creation pattern. Run once per table name below.
-- Tables: Peach, Tomato, Potato, Corn, Other_Plants

CREATE TABLE dbo.Peach (
    plant_type              NVARCHAR(50),
    disease_name            NVARCHAR(50),
    class_name              NVARCHAR(50),
    disease_severity        NVARCHAR(50),
    [Copy of plant_type]    NVARCHAR(50),
    [Copy of disease_name]  NVARCHAR(50),
    [Copy of class_name]    NVARCHAR(50),
    [Copy of disease_severity] NVARCHAR(50),
    [NUmb Label]            INT,           -- severity encoded 0..3
    Plant_cat               NVARCHAR(50),  -- Root / Grain / Fruit / Vegetable / ...
    Severity_risk_level     NVARCHAR(50),  -- Low / High
    is_fruit_crop           INT            -- 1 = fruit crop, 0 = not
);
GO

CREATE TABLE dbo.Tomato (
    plant_type              NVARCHAR(50),
    disease_name            NVARCHAR(50),
    class_name              NVARCHAR(50),
    disease_severity        NVARCHAR(50),
    [Copy of plant_type]    NVARCHAR(50),
    [Copy of disease_name]  NVARCHAR(50),
    [Copy of class_name]    NVARCHAR(50),
    [Copy of disease_severity] NVARCHAR(50),
    [NUmb Label]            INT,
    Plant_cat               NVARCHAR(50),
    Severity_risk_level     NVARCHAR(50),
    is_fruit_crop           INT
);
GO

CREATE TABLE dbo.Potato (
    plant_type              NVARCHAR(50),
    disease_name            NVARCHAR(50),
    class_name              NVARCHAR(50),
    disease_severity        NVARCHAR(50),
    [Copy of plant_type]    NVARCHAR(50),
    [Copy of disease_name]  NVARCHAR(50),
    [Copy of class_name]    NVARCHAR(50),
    [Copy of disease_severity] NVARCHAR(50),
    [NUmb Label]            INT,
    Plant_cat               NVARCHAR(50),
    Severity_risk_level     NVARCHAR(50),
    is_fruit_crop           INT
);
GO

CREATE TABLE dbo.Corn (
    plant_type              NVARCHAR(50),
    disease_name            NVARCHAR(50),
    class_name              NVARCHAR(50),
    disease_severity        NVARCHAR(50),
    [Copy of plant_type]    NVARCHAR(50),
    [Copy of disease_name]  NVARCHAR(50),
    [Copy of class_name]    NVARCHAR(50),
    [Copy of disease_severity] NVARCHAR(50),
    [NUmb Label]            INT,
    Plant_cat               NVARCHAR(50),
    Severity_risk_level     NVARCHAR(50),
    is_fruit_crop           INT
);
GO

CREATE TABLE dbo.Other_Plants (
    plant_type              NVARCHAR(50),
    disease_name            NVARCHAR(50),
    class_name              NVARCHAR(50),
    disease_severity        NVARCHAR(50),
    [Copy of plant_type]    NVARCHAR(50),
    [Copy of disease_name]  NVARCHAR(50),
    [Copy of class_name]    NVARCHAR(50),
    [Copy of disease_severity] NVARCHAR(50),
    [NUmb Label]            INT,
    Plant_cat               NVARCHAR(50),
    Severity_risk_level     NVARCHAR(50),
    is_fruit_crop           INT
);
GO
