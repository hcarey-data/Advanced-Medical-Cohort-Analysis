# Medical Cohort and Risk Analysis

## Stakeholder Question

This analysis project works to understand risk spread and risk customers by dividing the data into various segments (cohorts). This way, stakeholders will know which groups of patients to prioritize when administering care or calculating insurance costs. How can an insurance provider identify high-risk customer segments and understand the key factors influencing medical costs in order to improve risk assessment, optimize pricing strategies, and develop targeted customer management strategies?

##. Tools Used
-- SQL Server (SQL)
-- Power BI (Visualizations)

## Data Cleaning & Preparation

-- The analysis starts with doing data cleaning and exploratory data analysis (EDA) on the data within 'Insurance Cleaning and EDA.sql'. The dataset contains columns age, which represents the age of the patient, sex, which represents whether the patient is male or female, bmi (body mass index) which is a measure to determine a person's body fat, children, which shows how many children the patient has, smoker, which shows if the patient is a smoker or not, region, which shows which region the person is from, and charges, is how much insurance charges that the patient pays. For data cleaning within SQL Server, the number of rows and distinct rows are counted, duplicates are removed, and column data types are determined. Nulls are also checked for. Negative and unreasonable values from ages and bmi measurements are also removed. 

## Exploratory Data Analysis (EDA)

-- There are a total of about 274 patient smokers and 1064 patient non-smokers. The minimum patient age is 18 while the maximum patient age is 64. For example, 
the average charge for all the smokers in the dataset is about $32,000, while for non smokers, it's just around $8,500, around four times less than non-smokers.
Patients living in the southeast portion of the United States get charged the most on average. Men living in the southeast United States tend to have the highest bmi of 53.13. 

The data is further divided into cohorts within SQL Server for deeper insights. For instance, there are cohorts for age bands, bmi risk groups, dependency bands (which are based on how many children a patient has), insurance charge distribution cohorts, how those distributions rank, and the top charge contributors. This segmentation will help understand which groups are contributing the most charge-wise and who are most at risk health-wise.

'Insurance Cohort Comparisons.sql' calculates additional metrics for each cohort created earlier. Univariate and multivariate analysis are performed for each as percentiles, maximums, mininums, standard deviations, are all considered. 'Cohort Summary Tables.sql' and `Dimensions.sql` are additonal queries for providing summary statistics and fact and dimension table structuring. 


## Visualizations Overview

Visualizations are provided through 'Medical Insurance Project Visualization' PowerBI file. In the executive summary, we see that there are $17.75 million in charges across the entire dataset. The smoker-to-non-smoker ratio is 20%, and 1337 patients are insured overall. From the bar charts, we see that patients residing in the southeast United States contribute the most charges (5.4M) . For BMI class, patients with Obese I and Obese Class II+ both contribute the most in charges overall (5.6M and 5.5M respectively). 

Another important insight involves top performers and lost distribution. 4% of patients contribute to the top 1% of insurance charges. Smokers contribute to the higher groups of charges overall. The majority charges themselves range up to 10k, with smaller amounts going all the way up to 60k. More Obese and overweight patients contribute on the higher end of the charge spectrum as well. 

The Risk Intervention Structure & Non-Linear Cost Formation sheet allows for extensive univariate and multivariate analysis. What are the average charges for smoker and BMI Class? How is charge variance affected by whether a patient is a smoker or not and their age? These various tables on this sheet show these measures (including P90, P95, and P99 distributions) to help create a clearer picture of how these cohorts interact with each other and by themselves to influence insurance charge. 

Pricing Adequacy and Underwriting Profitability deals with "What if?" scenarios. In order to get an understanding of hypothetical outcomes, it was necessary to introduce a simulated insurance margin to derive a simulated total premium for the dataset. This will help
stakeholders get an idea of how charges and different variables will change under certain conditions. The average charges and charge standard deviations are calculated for the different cohorts. Under this hypothetical premium amount, the corresponding pricing can be judged accordingly for each patient segment.

Risk scoring & Governance plays a similar role. It assigns a risk tier for each patient based on their age, bmi, dependency rating, smoker status, and charge percentile. The different tiers are "low", "medium", "high", and "very high". Those patients with a "high" or "very high" risk tier would in turn be of more risk to the insurance company in filing a claim in the near future. Average charges, charge standard deviation, and policy counts are calculated for each tier as well along with slicers for more filtered analysis.

## Insights and Recommendations

In summation and as briefly stated previously, male patients residing in the southeastern United States that are obese or very obese tend to pay the most in insurance premiums. These individuals also seem to be the most at risk healthwise. As a result, the company should prioritize these individuals for healthcare programs, healthy eating, dieting, or other incentives to increase their body health and thus prevent them from possibly filing a claim. Since smokers tend to pay higher insurance premiums than non-smokers, it may be helpful to target the male southeastern residents who smoke with smoking awareness campaigns and possible insurance benefits if they agree to a plan to go into withdrawal and stop smoking. However, age also tends to be a strong indicator of a patient's need to file a claim. Since about 25% and 22% of total charges come from pre-seniors and late-middle aged individuals respectively, it may be of use to prioritize these groups for campaigns and incentives as well. The obese and smokers amoung these groups should then be given further priority. To lower the smoker ratio, it may be beneficial to not extend coverage to new customers who have a history of smoking. Conversely, it could help to extend coverage offerings to new patients residing in the southwestern portion of the United States who have a normal bmi class rating and who do not have a history of smoking. 





