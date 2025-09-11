SELECT *
FROM [dbo].[CovidDeaths$]
ORDER BY 2,3;

SELECT *
FROM [dbo].[CovidVaccinations$]
ORDER BY 2, 3;

--Looking At total cases vs total death 

SELECT 
		[location],[date],[total_cases],[total_deaths],
		([total_deaths]/[total_cases]) * 100 AS Death_percentage
FROM	[dbo].[CovidDeaths$]
--WHERE	[location] LIKE '%STATE%'
ORDER BY 1,2;

--Looking at the total cases vs population

SELECT	
		[location],[date],[total_cases],[population],
		([total_cases]/[population])* 100 AS death_percentage_by_population
FROM	[dbo].[CovidDeaths$]
--WHERE	[location] LIKE '%STATE%'
ORDER BY 1,2

--Looking at country with highest infection rate compare to population

SELECT	
		[location],[population],max([total_cases]) AS Highest_infection_count,
		max([total_cases]/[population]) * 100 AS percentpopulation_infected
FROM    [dbo].[CovidDeaths$]
GROUP BY [location], [population]
ORDER BY percentpopulation_infected DESC

-- showing country wih highest death count per population 

SELECT
        [location],max(cast([total_deaths]as bigint)) AS total_death_count
FROM    [dbo].[CovidDeaths$]
WHERE   [continent]is not null
GROUP BY [location]
ORDER BY total_death_count DESC

-- by continent

SELECT
        [continent],max(cast([total_deaths]as bigint)) AS total_death_count
FROM    [dbo].[CovidDeaths$]
WHERE   [continent]is not null
GROUP BY [continent]
ORDER BY total_death_count DESC

--Join two table together

SELECT *
FROM	[dbo].[CovidDeaths$] DEA
JOIN    [dbo].[CovidVaccinations$] VAC
ON		DEA.location = VAC.location
AND     DEA.date = VAC.date
where   DEA.continent is not null
ORDER BY 2,3

-- Looking At total population vs vaccination 

SELECT 
		DEA.continent, DEA.location,  DEA.date,
		DEA.population, VAC.[new_vaccinations],
SUM     (CONVERT (INT,VAC.new_vaccinations))
OVER    (PARTITION BY DEA.location ORDER BY DEA.location
        ,DEA.date) AS rolling_people_vaccination
FROM	 [dbo].[CovidDeaths$] DEA
JOIN     [dbo].[CovidVaccinations$] VAC
ON		 DEA.location = VAC.location
AND      DEA.date = VAC.date
where    DEA.continent is not null
ORDER BY 2,3;

-- use CTE


WITH POPVSVAC ([continent], [location], [date], [population], [new_vaccinations], rolling_people_vaccination) AS (
    SELECT 
        DEA.continent, 
        DEA.location, 
        DEA.date,
        DEA.population, 
        VAC.new_vaccinations,
        SUM(ISNULL(CONVERT(BIGINT, VAC.new_vaccinations), 0)) OVER (
            PARTITION BY DEA.location 
            ORDER BY DEA.date
        ) AS rolling_people_vaccination
    FROM [dbo].[CovidDeaths$] DEA
    JOIN [dbo].[CovidVaccinations$] VAC
        ON DEA.location = VAC.location
        AND DEA.date = VAC.date
    WHERE DEA.continent IS NOT NULL
)
SELECT 
    [continent],
    [location],
    [date],
    [population],
    [new_vaccinations],
    [rolling_people_vaccination],
    CASE 
        WHEN [population] = 0 THEN NULL
        ELSE (CAST([rolling_people_vaccination] AS FLOAT) / NULLIF([population], 0)) * 100
    END AS vaccination_percentage
FROM POPVSVAC;

-- TEMP TABLE 
drop table Percentpopulationvaccinated;


-- Create the table with appropriate data types and an additional column for percentage
CREATE TABLE Percentpopulationvaccinated
(
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population NUMERIC(15, 2), -- Added precision and scale for population
    new_vaccinations NUMERIC(15, 2), -- Added precision and scale
    rolling_people_vaccination NUMERIC(20, 2), -- Larger precision for rolling sum
    vaccination_percentage NUMERIC(5, 2) -- Column for percentage (up to 999.99%)
);

-- Insert data using a CTE to calculate the rolling sum and percentage
WITH RollingVaccinations AS (
    SELECT 
        DEA.continent,
        DEA.location,
        DEA.date,
        DEA.population,
        VAC.new_vaccinations,
        SUM(ISNULL(CONVERT(BIGINT, VAC.new_vaccinations), 0)) OVER (
            PARTITION BY DEA.location 
            ORDER BY DEA.date
        ) AS rolling_people_vaccination
    FROM [dbo].[CovidDeaths$] DEA
    JOIN [dbo].[CovidVaccinations$] VAC
        ON DEA.location = VAC.location
        AND DEA.date = VAC.date
    WHERE DEA.continent IS NOT NULL
)
INSERT INTO Percentpopulationvaccinated
(
    continent,
    location,
    date,
    population,
    new_vaccinations,
    rolling_people_vaccination,
    vaccination_percentage
)
SELECT 
    continent,
    location,
    date,
    population,
    new_vaccinations,
    rolling_people_vaccination,
    CASE 
        WHEN population = 0 THEN NULL
        ELSE (CAST(rolling_people_vaccination AS FLOAT) / NULLIF(population, 0)) * 100
    END AS vaccination_percentage
FROM RollingVaccinations;


SELECT 
    rolling_people_vaccination/
    population * 100
FROM [dbo].[Percentpopulationvaccinated];

-- creating views 

CREATE VIEW vw_VaccinationTrendsByLocation AS
SELECT 
    continent,
    location,
    date,
    population,
    new_vaccinations,
    rolling_people_vaccination,
    CASE 
        WHEN population = 0 THEN NULL
        ELSE (CAST(rolling_people_vaccination AS FLOAT) / NULLIF(population, 0)) * 100
    END AS vaccination_percentage
FROM [dbo].[Percentpopulationvaccinated];


create view Percentpopulationvaccinatedd as 
SELECT 
		DEA.continent, DEA.location,  DEA.date,
		DEA.population, VAC.[new_vaccinations],
SUM     (CONVERT (INT,VAC.new_vaccinations))
OVER    (PARTITION BY DEA.location ORDER BY DEA.location
        ,DEA.date) AS rolling_people_vaccination
FROM	 [dbo].[CovidDeaths$] DEA
JOIN     [dbo].[CovidVaccinations$] VAC
ON		 DEA.location = VAC.location
AND      DEA.date = VAC.date
where    DEA.continent is not null
--ORDER BY 2,3;

select *
from [dbo].[CovidDeaths$]
