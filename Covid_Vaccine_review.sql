-- Ordered by State, review % of doses that were administered compared to total doses distributed to jurisdiction to show new column creation
SELECT Jurisdiction_State_Territory_or_Federal_Entity, StateCode, Region, Total_doses_distributed, Total_doses_administered_by_jurisdiction, CAST(1.0*Total_doses_administered_by_jurisdiction/Total_doses_distributed * 100 AS decimal (5,2)) AS 'Percent of Doses Administered'
FROM [Covid].[dbo].[covid19_vaccinations_by_states]
WHERE StateCode NOT LIKE '%US%' AND StateCode NOT LIKE '%DD%'
ORDER BY Total_doses_distributed DESC;

-- Review % of state population with >=1 dose compared to average % to show subquery
SELECT Region, Jurisdiction_State_Territory_or_Federal_Entity, StateCode, [Percent_of_total_pop_with_at_least_one_dose], (SELECT AVG([Percent_of_total_pop_with_at_least_one_dose]) FROM [Covid].[dbo].[covid19_vaccinations_by_states]) AS 'Average_Percent_Administered'
FROM [Covid].[dbo].[covid19_vaccinations_by_states]
WHERE StateCode NOT LIKE '%US%' AND StateCode NOT LIKE '%DD%'
ORDER BY Region, Jurisdiction_State_Territory_or_Federal_Entity DESC;

-- Review % of state population with >=1 dose compared to average % as CTE to calculate difference
With Average_Pop AS
(SELECT Region, Jurisdiction_State_Territory_or_Federal_Entity, StateCode, [Percent_of_total_pop_with_at_least_one_dose], (SELECT AVG([Percent_of_total_pop_with_at_least_one_dose]) FROM [Covid].[dbo].[covid19_vaccinations_by_states]) AS 'Average_Percent_Administered'
FROM [Covid].[dbo].[covid19_vaccinations_by_states]
WHERE StateCode NOT LIKE '%US%' AND StateCode NOT LIKE '%DD%')

SELECT Region, Jurisdiction_State_Territory_or_Federal_Entity, StateCode, [Percent_of_total_pop_with_at_least_one_dose], Average_Percent_Administered, [Percent_of_total_pop_with_at_least_one_dose] - Average_Percent_Administered AS 'Diff_of_Actual_Average_Administered'
FROM Average_Pop
WHERE Region NOT LIKE '%Other%' AND Percent_of_total_pop_with_at_least_one_dose IS NOT NULL
ORDER BY Region ASC, Percent_of_total_pop_with_at_least_one_dose DESC;

-- 