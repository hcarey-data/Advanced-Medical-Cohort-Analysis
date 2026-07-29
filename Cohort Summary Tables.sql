USE Insurancedb;

/*
COHORTS SUMMARY TABLES FOR EACH COHORT
*/

-- Select all columns.
SELECT 
*
FROM dbo.vw_cohorts;

-- Ages Cohort Summary Table
CREATE OR ALTER VIEW vw_ages_cohort_summary AS 
SELECT
ages,
AVG(charges) AS avg_charges,
SUM(charges) AS total_charges,
MIN(charges) AS min_charge,
MAX(charges) AS max_charge,
COUNT(*) AS number_of_charges,
VAR(charges) AS charges_var,
STDEV(charges) AS charges_std,
1.0 * SUM(CASE WHEN top_10_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_10_age_share,
1.0 * SUM(CASE WHEN top_5_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_5_age_share,
1.0 * SUM(CASE WHEN top_1_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_1_age_share
FROM dbo.vw_cohorts
GROUP BY ages;



-- Band Cohort Summary Table
CREATE OR ALTER VIEW vw_band_cohort_summary AS 
SELECT
band,
AVG(charges) AS avg_charges,
SUM(charges) AS total_charges,
MIN(charges) AS min_charge,
MAX(charges) AS max_charge,
COUNT(*) AS number_of_charges,
VAR(charges) AS charges_var,
STDEV(charges) AS charges_std,
1.0 * SUM(CASE WHEN top_10_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_10_band_share,
1.0 * SUM(CASE WHEN top_5_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_5_band_share,
1.0 * SUM(CASE WHEN top_1_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_1_band_share
FROM dbo.vw_cohorts
GROUP BY band;


-- BMI Class Summary Table
CREATE OR ALTER VIEW vw_bmi_class_cohort_summary AS 
SELECT
bmi_class,
AVG(charges) AS avg_charges,
SUM(charges) AS total_charges,
MIN(charges) AS min_charge,
MAX(charges) AS max_charge,
COUNT(*) AS number_of_charges,
VAR(charges) AS charges_var,
STDEV(charges) AS charges_std,
1.0 * SUM(CASE WHEN top_10_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_10_bmi_class_share,
1.0 * SUM(CASE WHEN top_5_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_5_bmi_class_share,
1.0 * SUM(CASE WHEN top_1_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_1_bmi_class_share
FROM dbo.vw_cohorts
GROUP BY bmi_class;




-- Smoker Type Summary Table
CREATE OR ALTER VIEW vw_smoker_type_cohort_summary AS 
SELECT
smoker,
AVG(charges) AS avg_charges,
SUM(charges) AS total_charges,
MIN(charges) AS min_charge,
MAX(charges) AS max_charge,
COUNT(*) AS number_of_charges,
VAR(charges) AS charges_var,
STDEV(charges) AS charges_std,
1.0 * SUM(CASE WHEN top_10_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_10_smoker_share,
1.0 * SUM(CASE WHEN top_5_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_5_smoker_share,
1.0 * SUM(CASE WHEN top_1_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_1_smoker_share
FROM dbo.vw_cohorts
GROUP BY smoker;

-- Region Summary Table
CREATE OR ALTER VIEW vw_region_cohort_summary AS 
SELECT
region,
AVG(charges) AS avg_charges,
SUM(charges) AS total_charges,
MIN(charges) AS min_charge,
MAX(charges) AS max_charge,
COUNT(*) AS number_of_charges,
VAR(charges) AS charges_var,
STDEV(charges) AS charges_std,
1.0 * SUM(CASE WHEN top_10_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_10_region_share,
1.0 * SUM(CASE WHEN top_5_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_5_region_share,
1.0 * SUM(CASE WHEN top_1_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_1_region_share
FROM dbo.vw_cohorts
GROUP BY region;


-- Sex Summary Table
CREATE OR ALTER VIEW vw_sex_cohort_summary AS 
SELECT
sex,
AVG(charges) AS avg_charges,
SUM(charges) AS total_charges,
MIN(charges) AS min_charge,
MAX(charges) AS max_charge,
COUNT(*) AS number_of_charges,
VAR(charges) AS charges_var,
STDEV(charges) AS charges_std,
1.0 * SUM(CASE WHEN top_10_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_10_sex_share,
1.0 * SUM(CASE WHEN top_5_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_5_sex_share,
1.0 * SUM(CASE WHEN top_1_flag = 1 THEN 1 ELSE 0 END)/ NULLIF(COUNT(*), 0) AS top_1_sex_share
FROM dbo.vw_cohorts
GROUP BY sex;



-- KPI Table
CREATE OR ALTER VIEW vw_kpis AS
WITH median AS 
(
SELECT
*,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY charges) OVER() AS median_charge
FROM dbo.vw_cohorts
)

SELECT
SUM(charges) AS total_charges,
AVG(charges) AS average_charges,
VAR(charges) AS total_charges_var,
STDEV(charges) AS total_charges_std,
MAX(median_charge) AS median_charge,
1.0 * COUNT(CASE WHEN smoker = 1 THEN 1 END) / NULLIF(COUNT(*), 0) AS smoker_ratio,
1.0 * COUNT(CASE WHEN smoker = 0 THEN 1 END) / NULLIF(COUNT(*), 0) AS non_smoker_ratio,
AVG(CASE WHEN smoker = 1 THEN charges ELSE NULL END) AS avg_smoker_charges,
AVG(CASE WHEN smoker = 0 THEN charges ELSE NULL END) AS avg_non_smoker_charges,
COUNT(*) AS total_insured,
COUNT(CASE WHEN smoker = 1 THEN 1 END) AS total_smokers,
COUNT(CASE WHEN smoker = 0 THEN 1 END) AS total_non_smokers,
1.0 * SUM(CASE WHEN top_10_flag = 1 THEN charges ELSE 0 END) / NULLIF(SUM(charges), 0) AS top_10_cost_share,
1.0 * SUM(CASE WHEN top_5_flag = 1 THEN charges ELSE 0 END) / NULLIF(SUM(charges), 0) AS top_5_cost_share,
1.0 * SUM(CASE WHEN top_1_flag = 1 THEN charges ELSE 0 END) / NULLIF(SUM(charges), 0) AS top_1_cost_share
FROM median;




-- Validate all views before importing
EXEC sp_depends 'vw_ages_cohort_summary';
EXEC sp_depends 'vw_kpis';

-- Check row counts
SELECT 'vw_ages_cohort_summary' AS view_name, COUNT(*) AS row_count FROM vw_ages_cohort_summary
UNION ALL
SELECT 'vw_band_cohort_summary', COUNT(*) FROM vw_band_cohort_summary
UNION ALL
SELECT 'vw_bmi_class_cohort_summary', COUNT(*) FROM vw_bmi_class_cohort_summary
UNION ALL
SELECT 'vw_smoker_type_cohort_summary', COUNT(*) FROM vw_smoker_type_cohort_summary
UNION ALL
SELECT 'vw_region_cohort_summary', COUNT(*) FROM vw_region_cohort_summary
UNION ALL
SELECT 'vw_sex_cohort_summary', COUNT(*) FROM vw_sex_cohort_summary
UNION ALL
SELECT 'vw_kpis', COUNT(*) FROM vw_kpis;


