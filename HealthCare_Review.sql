--Calculate average uninsured % by region to show window function

SELECT DISTINCT Region, CAST(AVG(Uninsured) OVER (PARTITION BY Region) *100 AS DECIMAL(5,2)) AS 'Avg_Uninsured_by_Region'
FROM [Covid].[dbo].[Health_Care_Coverage_State];

-- Count of number of states in a region
SELECT Region, COUNT(*) AS Number_States_per_Region
FROM [Covid].[dbo].[Health_Care_Coverage_State]
GROUP BY Region;

--Limit results to only those with an average covered by employer of 50% or higher
SELECT Location, Employer
FROM [Covid].[dbo].[Health_Care_Coverage_State]
WHERE Employer >= .50;

--Reviewing top 10 states for Medicare coverage
SELECT TOP 10 CAST(Medicare AS DECIMAL (5,2)) AS Medicare, Location
FROM [Covid].[dbo].[Health_Care_Coverage_State]
ORDER BY Medicare DESC;

--Ranking Regions by % of population with Medicaid Coverage
SELECT Location, Region, FORMAT(Medicaid,'P') AS Percent_Medicaid_Covereage, RANK() OVER (PARTITION BY Region ORDER BY Medicaid DESC) AS Rank_in_Region
FROM [Covid].[dbo].[Health_Care_Coverage_State]
WHERE Location NOT LIKE '%United States%'
ORDER BY Region, Rank_in_Region;

--reviewing average uninsured in region for those with 7% or higher uninsured
SELECT Region, FORMAT(AVG(Uninsured),'P') AS 'Avg_Uninsured'
FROM [Covid].[dbo].[Health_Care_Coverage_State]
WHERE Uninsured IS NOT NULL
GROUP BY Region
HAVING AVG(Uninsured)*100 >= 7
ORDER BY [Avg_Uninsured] DESC;

--calculating quartiles, median, and iqr of employer funded healthcare

WITH quartiles AS
(SELECT TOP 1 Percentile_Cont(0.25) WITHIN GROUP(Order By Employer) OVER() As Q1, Percentile_Cont(0.5) WITHIN GROUP(Order By Employer) OVER() As Median, Percentile_Cont(0.75) WITHIN GROUP(Order By Employer) OVER() As Q3
FROM [Covid].[dbo].[Health_Care_Coverage_State])

SELECT FORMAT(Q1, 'P') AS Q1_Employer_Covered, FORMAT(Median, 'P') AS Median_Employer_Covered, FORMAT(Q3, 'P') AS Q3_Employer_Covered, FORMAT(Q3-Q1, 'P') AS IQR_Employer_Covered
FROM quartiles;


