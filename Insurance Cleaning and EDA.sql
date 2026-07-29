USE Insurancedb;

-- Display all columns.
SELECT *
FROM dbo.insurance;

-- Display column data types
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'insurance';

-- Count the number of rows.
SELECT COUNT(*) AS no_of_rows
FROM dbo.insurance;

-- Count distinct rows
SELECT 
COUNT(*) AS no_of_distinct_rows
FROM 
(SELECT 
DISTINCT *
FROM dbo.insurance) t;

-- Find duplicate rows
WITH duplicates AS (
	SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY age, sex, bmi, children, smoker, region, charges ORDER BY (SELECT NULL)) AS r_n
	FROM dbo.insurance
)

SELECT *
FROM duplicates
WHERE r_n > 1;

-- Count the number of nulls
SELECT 
(SELECT COUNT(CASE WHEN age IS NULL THEN 1 END) FROM dbo.insurance) AS age_nulls, 
(SELECT COUNT(sex) FROM dbo.insurance WHERE sex IS NULL) AS sex_nulls, 
(SELECT COUNT(bmi) FROM dbo.insurance WHERE bmi IS NULL) AS bmi_nulls, 
(SELECT COUNT(children) FROM dbo.insurance WHERE children IS NULL) AS children_nulls, 
(SELECT COUNT(smoker) FROM dbo.insurance WHERE smoker IS NULL) AS smoker_nulls, 
(SELECT COUNT(region) FROM dbo.insurance WHERE region IS NULL) AS region_nulls,
(SELECT COUNT(charges) FROM dbo.insurance WHERE charges IS NULL) AS charges_nulls

-- Find the maximum charges for all rows, between sex, and region
SELECT MAX(charges) As max_charge
FROM dbo.insurance;

SELECT sex, MAX(charges) As max_charge_per_sex
FROM dbo.insurance
GROUP BY sex;

SELECT region, MAX(charges) As max_charge_per_region
FROM dbo.insurance
GROUP BY region;

-- Find negative charges. There are no negative charges.
SELECT *
FROM dbo.insurance
WHERE charges < 0;

-- Find unrealistic bmi measurements
SELECT *
FROM dbo.insurance
WHERE bmi < 5.0 OR bmi > 60;


-- Find negative ages or ineligible ages.
SELECT *
FROM dbo.insurance
WHERE age < 0 or age BETWEEN 0 AND 17;

-- Find negative or abnormal children counts
SELECT *
FROM dbo.insurance
WHERE children > 10 OR children < 0;


-- Display bmi measurements for each sex in each region
SELECT sex, region, bmi, ROW_NUMBER() OVER(PARTITION BY sex, region ORDER BY bmi DESC) AS bmi_row
FROM dbo.insurance
ORDER BY bmi DESC;

-- Find the average insurance charges per region
select region, AVG(charges) AS [average charges]
from dbo.[insurance]
group by region
order by [average charges] DESC

-- Find average charges per smoker (if they are a smoker or non-smoker)
select smoker, AVG(charges) AS [average charges by smoker]
from dbo.[insurance]
group by smoker
order by [average charges by smoker]

-- Find average charges, region, and total amount of smokers and non-smokers
select smoker, region, COUNT(*) AS [count], AVG(charges) AS [avg_charges]
from dbo.[insurance]
group by smoker, region 
order by smoker, [avg_charges] DESC

-- Find minimum and maximum ages
SELECT MIN(age) AS min, MAX(age) AS max
FROM dbo.insurance;

-- Count smokers
SELECT COUNT(*) AS smokers
FROM dbo.insurance
WHERE smoker = 1;

-- Count non-smokers
SELECT COUNT(*) AS non_smokers
FROM dbo.insurance
WHERE smoker = 0;

-- Create Data View of cleaned dataset
CREATE OR ALTER VIEW insurance_set AS
WITH duplicates_removed AS (
	SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY age, sex, bmi, children, smoker, region, charges ORDER BY (SELECT NULL)) AS r_n
	FROM dbo.insurance	
)

SELECT age, sex, bmi, children, smoker, region, charges
FROM duplicates_removed
WHERE r_n = 1;


-- Create cohort variable table view
CREATE OR ALTER VIEW vw_cohorts AS
WITH age_band AS (
	SELECT
	*,
	CASE
		WHEN age IS NULL THEN 'No Age Listed'
		WHEN age < 18 THEN 'Under 18'
		WHEN age >= 18 AND age <= 29 THEN 'Young Adult'
		WHEN age >= 30 AND age <= 39 THEN 'Early Middle Age'
		WHEN age >= 40 AND age <= 49 THEN 'Late Middle Age'
		WHEN age >= 50 AND age <= 59 THEN 'Pre-Senior'
		WHEN age > 59 THEN 'Senior Risk'	
	END AS ages
	FROM dbo.insurance_set
), bmi_risk_group AS (
	SELECT 
	*,
	CASE
	WHEN bmi IS NULL THEN 'No bmi Listed'
	WHEN bmi < 18.5 THEN 'Underweight'
	WHEN bmi >= 18.5 AND bmi <= 24.9 THEN 'Normal'
	WHEN bmi > 24.9 AND bmi <= 29.9 THEN 'Overweight'
	WHEN bmi > 29.9 AND bmi <= 34.9 THEN 'Obese I'
	ELSE 'Obese Class II+' 
	END AS bmi_class
	FROM age_band
), dependent_band AS (
	SELECT 
	*,
	CASE
	WHEN children IS NULL THEN 'No children listed'
	WHEN children = 0 THEN 'No Dependents'
	WHEN children >= 1 AND children <=2 THEN 'Moderate Dependents'
	WHEN children > 2 THEN 'High Dependents'
	END AS band
	FROM bmi_risk_group
), distributions_asc AS (
	SELECT 
	*,
	CUME_DIST() OVER(ORDER BY charges) AS charge_cum_dist_asc
	FROM dependent_band
), charge_percentile_tier AS (
	SELECT
	*,
	CASE
	WHEN charge_cum_dist_asc >= 0.99 THEN 'Top 1%'
	WHEN charge_cum_dist_asc >= 0.95 AND charge_cum_dist_asc < 0.99 THEN '95-99%'
	WHEN charge_cum_dist_asc >= 0.90 AND charge_cum_dist_asc < 0.95 THEN '90-95%'
	WHEN charge_cum_dist_asc >= 0.75 AND charge_cum_dist_asc < 0.90 THEN '75-90%'
	WHEN charge_cum_dist_asc >= 0.50 AND charge_cum_dist_asc < 0.75 THEN '50-75%'
	WHEN charge_cum_dist_asc < 0.50 THEN 'Bottom 50%'
	END AS percentile_tier
	FROM distributions_asc
), top_thresholds AS (
	SELECT 
	*,
	CASE WHEN charge_cum_dist_asc >= 0.90 THEN 1 ELSE 0 END AS top_10_flag,
	CASE WHEN charge_cum_dist_asc >= 0.95 THEN 1 ELSE 0 END AS top_5_flag,
	CASE WHEN charge_cum_dist_asc >= 0.99 THEN 1 ELSE 0 END AS top_1_flag
	FROM charge_percentile_tier
)

	
SELECT sex, 
	   bmi, 
	   children, 
	   smoker, 
	   region, 
	   charges,
	   age,
	   ages, 
	   bmi_class, 
	   band, 
	   percentile_tier, 
	   top_10_flag, 
	   top_5_flag, 
	   top_1_flag,
	   charge_cum_dist_asc
FROM top_thresholds;


