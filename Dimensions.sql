USE Insurancedb;

SELECT
*
FROM dbo.vw_cohorts;


CREATE OR ALTER VIEW vw_ages_sort AS
SELECT
DISTINCT
ages,
CASE
WHEN ages = 'Young Adult' THEN 1
WHEN ages = 'Early Middle Age' THEN 2
WHEN ages = 'Late Middle Age' THEN 3
WHEN ages = 'Pre-Senior' THEN 4
WHEN ages = 'Senior Risk' THEN 5
END AS sort_order
FROM dbo.vw_cohorts;

CREATE OR ALTER VIEW vw_band_sort AS
SELECT
DISTINCT
band,
CASE
WHEN band = 'No Dependents' THEN 0
WHEN band = 'Moderate Dependents' THEN 1
WHEN band = 'High Dependents' THEN 2
END AS sort_order
FROM dbo.vw_cohorts;

CREATE OR ALTER VIEW vw_bmi_class_sort AS
SELECT
DISTINCT
bmi_class,
CASE
WHEN bmi_class = 'Underweight' THEN 1
WHEN bmi_class = 'Normal' THEN 2
WHEN bmi_class = 'Overweight' THEN 3
WHEN bmi_class = 'Obese I' THEN 4
WHEN bmi_class = 'Obese Class II+' THEN 5
END AS sort_order
FROM dbo.vw_cohorts; 


CREATE OR ALTER VIEW vw_smoker_type_class_sort AS
SELECT
DISTINCT
smoker,
CASE
WHEN smoker = 0 THEN 0
WHEN smoker = 1 THEN 1
END AS sort_order
FROM dbo.vw_cohorts; 



CREATE OR ALTER VIEW vw_region_class_sort AS
SELECT
DISTINCT
region,
CASE
WHEN region = 'northeast' THEN 1
WHEN region = 'northwest' THEN 2
WHEN region = 'southeast' THEN 3
WHEN region = 'southwest' THEN 4
END AS sort_order
FROM dbo.vw_cohorts;

CREATE OR ALTER VIEW vw_sex_class_sort AS
SELECT
DISTINCT
sex,
CASE
WHEN sex = 'male' THEN 1
WHEN sex = 'female' THEN 2
END AS sort_order
FROM dbo.vw_cohorts;

