SELECT *
FROM [dbo].[nigerian_agriculture_animal_health_veterinary]

SELECT DISTINCT [disease]
FROM [dbo].[nigerian_agriculture_animal_health_veterinary]

-- changing ppr and fmd to there fullname 

SELECT [disease],
CASE WHEN [disease] = 'PPR' THEN 'Peste des petits ruminants'
     WHEN [disease] = 'FMD' THEN 'Foot-and-Mouth Disease'
     WHEN [disease] = 'african_swine_fever' THEN 'African swine fever'
     WHEN [disease] = 'newcastle_disease' THEN 'Newcastle disease'
     ELSE  [disease]
     END
FROM [dbo].[nigerian_agriculture_animal_health_veterinary]


UPDATE [dbo].[nigerian_agriculture_animal_health_veterinary]
SET [disease]= CASE WHEN [disease] =  'PPR' THEN 'Peste des petits ruminants'
     WHEN [disease] = 'FMD' THEN 'Foot-and-Mouth Disease'
     WHEN [disease] = 'african_swine_fever' THEN 'African swine fever'
     WHEN [disease] = 'newcastle_disease' THEN 'Newcastle disease'
     ELSE [disease]
     END

     SELECT [disease]
     FROM [dbo].[nigerian_agriculture_animal_health_veterinary]

     --Count total incidents, affected animals, and deaths

     SELECT COUNT  (*) AS total_incidents,
     SUM (deaths) AS Total_Death,
     SUM (affected_count) AS Total_Affected
     FROM [dbo].[nigerian_agriculture_animal_health_veterinary]

     -- Incidents by state or animal type,Identify hotspots or most affected animals.

     SELECT state, COUNT(*) AS incident_count, 
     SUM ([deaths]) AS total_deaths
     FROM [dbo].[nigerian_agriculture_animal_health_veterinary]
     GROUP BY state
     ORDER BY incident_count DESC

   SELECT animal_type, COUNT(*) AS incident_count, 
     SUM ([deaths]) AS total_deaths
     FROM [dbo].[nigerian_agriculture_animal_health_veterinary]
     GROUP BY animal_type
     ORDER BY incident_count DESC

     --Most common diseases and their impact, Rank diseases by frequency or mortality rate

     SELECT disease, COUNT(*) AS occurrences, 
     AVG(deaths / affected_count) AS mortality_rate
     FROM [dbo].[nigerian_agriculture_animal_health_veterinary]
     GROUP BY disease
     ORDER BY occurrences

    -- Treatment effectiveness.Compare outcomes (e.g., mortality) across treatments.
   
   SELECT 
    treatment, 
    AVG(CAST(deaths AS FLOAT) / NULLIF(affected_count, 0)) AS avg_mortality_rate,
    SUM(affected_count) AS total_affected
FROM nigerian_agriculture_animal_health_veterinary
GROUP BY treatment
ORDER BY avg_mortality_rate ASC;

-- Recent incidents (e.g., last year).Filter by date to focus on current data

SELECT TOP 10 *
FROM [dbo].[nigerian_agriculture_animal_health_veterinary]
WHERE incident_date >= '2024-01-01'
ORDER BY incident_date DESC;

