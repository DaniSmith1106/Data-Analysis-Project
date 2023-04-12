/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Jurisdiction_State_Territory_or_Federal_Entity]
      ,[StateCode]
      ,[Region]
      ,[Total_doses_distributed]
      ,[Doses_distributed_per_100K_pop]
      ,[Doses_distributed_by_jurisdiction_per_100K_of_18_pop]
      ,[Total_doses_administered_by_jurisdiction]
      ,[Doses_administered_by_jurisdiction_per_100K_pop]
      ,[Doses_administered_by_jurisdiction_to_18_pop]
      ,[Doses_administered_by_jurisdiction_per_100K_of_18_pop]
      ,[Residents_with_at_least_one_dose]
      ,[Percent_of_total_pop_with_at_least_one_dose]
      ,[Residents_18_with_at_least_one_dose]
      ,[Percent_of_18_pop_with_at_least_one_dose]
      ,[Residents_with_a_completed_primary_series]
      ,[Percent_of_total_pop_with_a_completed_primary_series]
      ,[Residents_18_with_a_completed_primary_series]
      ,[Percent_of_18_pop_with_a_completed_primary_series]
      ,[Total_number_of_original_Pfizer_doses_distributed]
      ,[Total_number_of_Pfizer_updated_booster_doses_distributed]
      ,[Total_number_of_original_Moderna_doses_distributed]
      ,[Total_number_of_Moderna_updated_booster_doses_distributed]
      ,[Total_number_of_Janssen_doses_distributed]
      ,[Total_number_of_Novavax_doses_distributed]
      ,[Total_number_of_doses_from_other_manufacturer_distributed]
      ,[Total_number_of_Janssen_doses_administered]
      ,[Total_number_of_original_Moderna_doses_administered]
      ,[Total_number_of_Moderna_updated_booster_doses_administered]
      ,[Total_number_of_original_Pfizer_doses_administered]
      ,[Total_number_of_Pfizer_updated_booster_doses_administered]
      ,[Total_number_of_Novavax_doses_administered]
      ,[Total_number_of_doses_from_other_manufacturer_administered]
      ,[Residents_65_with_at_least_one_dose]
      ,[Percent_of_65_pop_with_at_least_one_dose]
      ,[Residents_65_with_a_completed_primary_series]
      ,[Percent_of_65_pop_with_a_completed_primary_series]
      ,[Doses_administered_by_jurisdiction_to_65_pop]
      ,[Doses_administered_by_jurisdiction_per_100K_of_65_pop]
      ,[Doses_distributed_by_jurisdiction_per_100K_of_65_pop]
      ,[Residents_12_with_at_least_one_dose]
      ,[Percent_of_12_pop_with_at_least_one_dose]
      ,[Residents_12_with_a_completed_primary_series]
      ,[Percent_of_12_pop_with_a_completed_primary_series]
      ,[Doses_administered_by_jurisdiction_to_12_pop]
      ,[Doses_administered_by_jurisdiction_per_100K_of_12_pop]
      ,[Doses_distributed_by_jurisdiction_per_100K_of_12_pop]
      ,[Residents_5_with_at_least_one_dose]
      ,[Percent_of_5_pop_with_at_least_one_dose]
      ,[Residents_5_with_a_completed_primary_series]
      ,[Percent_of_5_pop_with_a_completed_primary_series]
      ,[Doses_administered_by_jurisdiction_to_5_pop]
      ,[Doses_administered_by_jurisdiction_per_100K_of_5_pop]
      ,[Doses_distributed_by_jurisdiction_per_100K_of_5_pop]
      ,[Residents_with_an_updated_bivalent_booster_dose]
      ,[Percent_of_pop_with_an_updated_bivalent_booster_dose]
      ,[Residents_5_with_an_updated_bivalent_booster_dose]
      ,[Percent_of_5_pop_with_an_updated_bivalent_booster_dose]
      ,[Residents_12_with_an_updated_bivalent_booster_dose]
      ,[Percent_of_12_pop_with_an_updated_bivalent_booster_dose]
      ,[Residents_18_with_an_updated_bivalent_booster_dose]
      ,[Percent_of_18_pop_with_an_updated_bivalent_booster_dose]
      ,[Residents_65_with_an_updated_bivalent_booster_dose]
      ,[Percent_of_65_pop_with_an_updated_bivalent_booster_dose]
      ,[Children_5_with_at_least_one_dose]
      ,[Total_number_of_updated_bivalent_booster_doses_administered]
  FROM [Covid].[dbo].[covid19_vaccinations_by_states]

  -- joining covid and healtcare dare to review population >65 with doses and covered by Medicare
  SELECT c.Jurisdiction_State_Territory_or_Federal_Entity, c.Region, CAST(c.[Percent_of_65_pop_with_at_least_one_dose] AS DECIMAL (5,2)) AS Percent_of_65_pop_with_at_least_one_dose, CAST(c.[Percent_of_65_pop_with_an_updated_bivalent_booster_dose] AS DECIMAL (5,2)) AS Percent_of_65_pop_with_an_updated_bivalent_booster_dose, CAST(h.Medicare*100 AS DECIMAL (5,2)) AS Percent_Covered_by_Medicare
  FROM [Covid].[dbo].[covid19_vaccinations_by_states] AS c
  INNER JOIN [Covid].[dbo].[Health_Care_Coverage_State] AS h
  ON c.StateCode = h.StateCode
  WHERE c.Region != 'Other' AND c.[Percent_of_65_pop_with_at_least_one_dose] IS NOT NULL
  ORDER BY h.Medicare DESC;

   --Inner join and math conversion example
  SELECT c.Jurisdiction_State_Territory_or_Federal_Entity, c.Region, c.[Total_doses_distributed], c.[Total_doses_administered_by_jurisdiction], FORMAT(([Total_doses_distributed]-[Total_doses_administered_by_jurisdiction] -0.0)/[Total_doses_distributed], 'P') AS Percent_Doses_Not_Administered, CAST(h.Uninsured*100 AS DECIMAL (5,2)) AS Percent_Uninsured
  FROM [Covid].[dbo].[covid19_vaccinations_by_states] AS c
  INNER JOIN [Covid].[dbo].[Health_Care_Coverage_State] AS h
  ON c.StateCode = h.StateCode
  WHERE c.Region != 'Other' AND c.[Total_doses_distributed] IS NOT NULL
  ORDER BY c.Jurisdiction_State_Territory_or_Federal_Entity, h.Uninsured DESC;