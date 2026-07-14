USE Insurancedb;

-- Show all columns
SELECT 
*
FROM dbo.vw_cohorts;


/** 
SINGLE COHORT METRICS AND ANALYSIS
**/
-- Calculate advanced metrics and percentiles for age groups

CREATE OR ALTER VIEW vw_ages_metrics AS 
WITH percentiles AS (
	SELECT
	ages,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY ages) AS lower_quartile,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY ages) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY ages) AS upper_quartile,
	PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY ages) AS P90,
	PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY ages) AS P95,
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY ages) AS P99
	FROM dbo.vw_cohorts
), materialized_percentiles AS (
	SELECT 
	DISTINCT 
	ages,
	lower_quartile, 
	median, 
	upper_quartile, 
	P90, 
	P95, 
	P99
	FROM percentiles
), aggregates AS (
	SELECT 
	ages, 
	COUNT(*) AS total_records,
	AVG(charges) AS avg_charges,
	SUM(charges) AS total_charges,
	MIN(charges) AS min_charge,
	MAX(charges) AS max_charge,
	VAR(charges) AS charges_variance,
	STDEV(charges) AS charges_std,
	(STDEV(charges)/AVG(charges)) AS coefficient_of_variation
	FROM dbo.vw_cohorts
	GROUP BY ages
)

SELECT 
m_p.ages,
total_records,
avg_charges,
total_charges,
min_charge,
max_charge,
charges_variance,
charges_std,
coefficient_of_variation,
lower_quartile, 
median, 
upper_quartile, 
(upper_quartile - lower_quartile) AS interquartile_range,
P90,
P95,
P99
FROM materialized_percentiles m_p
JOIN aggregates a
ON m_p.ages = a.ages;


-- Calculate advanced metrics and percentiles for bmi_class
CREATE OR ALTER VIEW vw_bmi_class_metrics AS 
WITH percentiles AS (
	SELECT
	bmi_class,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class) AS lower_quartile,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class) AS upper_quartile,
	PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class) AS P90,
	PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class) AS P95,
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class) AS P99
	FROM dbo.vw_cohorts
), materialized_percentiles AS (
	SELECT 
	DISTINCT 
	bmi_class,
	lower_quartile, 
	median, 
	upper_quartile, 
	P90, 
	P95, 
	P99
	FROM percentiles
), aggregates AS (
	SELECT 
	bmi_class, 
	COUNT(*) AS total_records,
	AVG(charges) AS avg_charges,
	SUM(charges) AS total_charges,
	MIN(charges) AS min_charge,
	MAX(charges) AS max_charge,
	VAR(charges) AS charges_variance,
	STDEV(charges) AS charges_std,
	(STDEV(charges)/AVG(charges)) AS coefficient_of_variation
	FROM dbo.vw_cohorts
	GROUP BY bmi_class
)

SELECT 
m_p.bmi_class,
total_records,
avg_charges,
total_charges,
min_charge,
max_charge,
charges_variance,
charges_std,
coefficient_of_variation,
lower_quartile, 
median, 
upper_quartile, 
(upper_quartile - lower_quartile) AS interquartile_range,
P90,
P95,
P99
FROM materialized_percentiles m_p
JOIN aggregates a
ON m_p.bmi_class = a.bmi_class;



-- Calculate advanced metrics and percentiles for smoker
CREATE OR ALTER VIEW vw_smoker_metrics AS 
WITH percentiles AS (
	SELECT
	smoker,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker) AS lower_quartile,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker) AS upper_quartile,
	PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker) AS P90,
	PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker) AS P95,
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker) AS P99
	FROM dbo.vw_cohorts
), materialized_percentiles AS (
	SELECT 
	DISTINCT 
	smoker,
	lower_quartile, 
	median, 
	upper_quartile, 
	P90, 
	P95, 
	P99
	FROM percentiles
), aggregates AS (
	SELECT 
	smoker, 
	COUNT(*) AS total_records,
	AVG(charges) AS avg_charges,
	SUM(charges) AS total_charges,
	MIN(charges) AS min_charge,
	MAX(charges) AS max_charge,
	VAR(charges) AS charges_variance,
	STDEV(charges) AS charges_std,
	(STDEV(charges)/AVG(charges)) AS coefficient_of_variation
	FROM dbo.vw_cohorts
	GROUP BY smoker
)

SELECT 
CASE
WHEN m_p.smoker = 1 THEN 'Smoker' 
WHEN m_p.smoker = 0 THEN 'Non-Smoker'
END AS smoker_type,
total_records,
avg_charges,
total_charges,
min_charge,
max_charge,
charges_variance,
charges_std,
coefficient_of_variation,
lower_quartile, 
median, 
upper_quartile, 
(upper_quartile - lower_quartile) AS interquartile_range,
P90,
P95,
P99
FROM materialized_percentiles m_p
JOIN aggregates a
ON m_p.smoker = a.smoker;




-- Calculate advanced metrics and percentiles for band
CREATE OR ALTER VIEW vw_band_metrics AS 
WITH percentiles AS (
	SELECT
	band,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band) AS lower_quartile,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band) AS upper_quartile,
	PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band) AS P90,
	PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band) AS P95,
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band) AS P99
	FROM dbo.vw_cohorts
), materialized_percentiles AS (
	SELECT 
	DISTINCT 
	band,
	lower_quartile, 
	median, 
	upper_quartile, 
	P90, 
	P95, 
	P99
	FROM percentiles
), aggregates AS (
	SELECT 
	band, 
	COUNT(*) AS total_records,
	AVG(charges) AS avg_charges,
	SUM(charges) AS total_charges,
	MIN(charges) AS min_charge,
	MAX(charges) AS max_charge,
	VAR(charges) AS charges_variance,
	STDEV(charges) AS charges_std,
	(STDEV(charges)/AVG(charges)) AS coefficient_of_variation
	FROM dbo.vw_cohorts
	GROUP BY band
)

SELECT 
m_p.band,
total_records,
avg_charges,
total_charges,
min_charge,
max_charge,
charges_variance,
charges_std,
coefficient_of_variation,
lower_quartile, 
median, 
upper_quartile, 
(upper_quartile - lower_quartile) AS interquartile_range,
P90,
P95,
P99
FROM materialized_percentiles m_p
JOIN aggregates a
ON m_p.band = a.band;



/*
MULTIPLE COHORT METRICS AND ANALYSIS
*/

-- Calculate advanced metrics and percentiles for smoker x bmi_class
CREATE OR ALTER VIEW vw_smoker_bmi_class_metrics AS 
WITH percentiles AS (
	SELECT
	smoker,
	bmi_class,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, bmi_class) AS lower_quartile,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, bmi_class) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, bmi_class) AS upper_quartile,
	PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, bmi_class) AS P90,
	PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, bmi_class) AS P95,
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, bmi_class) AS P99
	FROM dbo.vw_cohorts
), materialized_percentiles AS (
	SELECT 
	DISTINCT 
	smoker,
	bmi_class,
	lower_quartile, 
	median, 
	upper_quartile, 
	P90, 
	P95, 
	P99
	FROM percentiles
), aggregates AS (
	SELECT 
	smoker,
	bmi_class,
	COUNT(*) AS total_records,
	AVG(charges) AS avg_charges,
	SUM(charges) AS total_charges,
	MIN(charges) AS min_charge,
	MAX(charges) AS max_charge,
	VAR(charges) AS charges_variance,
	STDEV(charges) AS charges_std,
	(STDEV(charges)/AVG(charges)) AS coefficient_of_variation
	FROM dbo.vw_cohorts
	GROUP BY smoker, bmi_class
)

SELECT 
CASE
WHEN m_p.smoker = 1 THEN 'Smoker'
WHEN m_p.smoker = 0 THEN 'Non-Smoker'
END AS smoker_type,
m_p.bmi_class,
total_records,
avg_charges,
total_charges,
min_charge,
max_charge,
charges_variance,
charges_std,
coefficient_of_variation,
lower_quartile, 
median, 
upper_quartile, 
(upper_quartile - lower_quartile) AS interquartile_range,
P90,
P95,
P99
FROM materialized_percentiles m_p
JOIN aggregates a
ON m_p.smoker = a.smoker AND m_p.bmi_class = a.bmi_class;



-- Calculate advanced metrics and percentiles for smoker x ages band
CREATE OR ALTER VIEW vw_smoker_ages_metrics AS 
WITH percentiles AS (
	SELECT
	smoker,
	ages,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, ages) AS lower_quartile,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, ages) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, ages) AS upper_quartile,
	PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, ages) AS P90,
	PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, ages) AS P95,
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY smoker, ages) AS P99
	FROM dbo.vw_cohorts
), materialized_percentiles AS (
	SELECT 
	DISTINCT 
	smoker,
	ages,
	lower_quartile, 
	median, 
	upper_quartile, 
	P90, 
	P95, 
	P99
	FROM percentiles
), aggregates AS (
	SELECT 
	smoker,
	ages,
	COUNT(*) AS total_records,
	AVG(charges) AS avg_charges,
	SUM(charges) AS total_charges,
	MIN(charges) AS min_charge,
	MAX(charges) AS max_charge,
	VAR(charges) AS charges_variance,
	STDEV(charges) AS charges_std,
	(STDEV(charges)/AVG(charges)) AS coefficient_of_variation
	FROM dbo.vw_cohorts
	GROUP BY smoker, ages
)

SELECT 
CASE
WHEN m_p.smoker = 1 THEN 'Smoker'
WHEN m_p.smoker = 0 THEN 'Non-Smoker'
END AS smoker_type,
m_p.ages,
total_records,
avg_charges,
total_charges,
min_charge,
max_charge,
charges_variance,
charges_std,
coefficient_of_variation,
lower_quartile, 
median, 
upper_quartile, 
(upper_quartile - lower_quartile) AS interquartile_range,
P90,
P95,
P99
FROM materialized_percentiles m_p
JOIN aggregates a
ON m_p.smoker = a.smoker AND m_p.ages = a.ages;



-- Calculate advanced metrics and percentiles for bmi_class x ages band
CREATE OR ALTER VIEW vw_bmi_class_ages_metrics AS 
WITH percentiles AS (
	SELECT
	bmi_class,
	ages,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class, ages) AS lower_quartile,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class, ages) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class, ages) AS upper_quartile,
	PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class, ages) AS P90,
	PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class, ages) AS P95,
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY bmi_class, ages) AS P99
	FROM dbo.vw_cohorts
), materialized_percentiles AS (
	SELECT 
	DISTINCT 
	bmi_class,
	ages,
	lower_quartile, 
	median, 
	upper_quartile, 
	P90, 
	P95, 
	P99
	FROM percentiles
), aggregates AS (
	SELECT
	bmi_class, 
	ages,
	COUNT(*) AS total_records,
	AVG(charges) AS avg_charges,
	SUM(charges) AS total_charges,
	MIN(charges) AS min_charge,
	MAX(charges) AS max_charge,
	VAR(charges) AS charges_variance,
	STDEV(charges) AS charges_std,
	(STDEV(charges)/AVG(charges)) AS coefficient_of_variation
	FROM dbo.vw_cohorts
	GROUP BY bmi_class, ages
)

SELECT
m_p.bmi_class, 
m_p.ages,
total_records,
avg_charges,
total_charges,
min_charge,
max_charge,
charges_variance,
charges_std,
coefficient_of_variation,
lower_quartile, 
median, 
upper_quartile, 
(upper_quartile - lower_quartile) AS interquartile_range,
P90,
P95,
P99
FROM materialized_percentiles m_p
JOIN aggregates a
ON m_p.bmi_class = a.bmi_class AND m_p.ages = a.ages;




-- Calculate percentiles and advanced metrics for dependents band x smoker
CREATE OR ALTER VIEW vw_band_smoker_metrics AS 
WITH percentiles AS (
	SELECT
	band,
	smoker,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band, smoker) AS lower_quartile,
	PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band, smoker) AS median,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band, smoker) AS upper_quartile,
	PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band, smoker) AS P90,
	PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band, smoker) AS P95,
	PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY charges ASC) OVER(PARTITION BY band, smoker) AS P99
	FROM dbo.vw_cohorts
), materialized_percentiles AS (
	SELECT 
	DISTINCT 
	band,
	smoker,
	lower_quartile, 
	median, 
	upper_quartile, 
	P90, 
	P95, 
	P99
	FROM percentiles
), aggregates AS (
	SELECT 
	band, 
	smoker,
	COUNT(*) AS total_records,
	AVG(charges) AS avg_charges,
	SUM(charges) AS total_charges,
	MIN(charges) AS min_charge,
	MAX(charges) AS max_charge,
	VAR(charges) AS charges_variance,
	STDEV(charges) AS charges_std,
	(STDEV(charges)/AVG(charges)) AS coefficient_of_variation
	FROM dbo.vw_cohorts
	GROUP BY band, smoker
)

SELECT
m_p.band, 
CASE
WHEN m_p.smoker = 1 THEN 'Smoker'
WHEN m_p.smoker = 0 THEN 'Non-Smoker'
END AS smoker_type,
total_records,
avg_charges,
total_charges,
min_charge,
max_charge,
charges_variance,
charges_std,
coefficient_of_variation,
lower_quartile, 
median, 
upper_quartile, 
(upper_quartile - lower_quartile) AS interquartile_range,
P90,
P95,
P99
FROM materialized_percentiles m_p
JOIN aggregates a
ON m_p.band = a.band AND m_p.smoker = a.smoker;




