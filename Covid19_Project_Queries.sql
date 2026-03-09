-- Database is created to look into the project seperately.

CREATE DATABASE COVID_19;
USE COVID_19;

SHOW TABLES;


-- Verifing the actual dataset imported is correct or not
SELECT 
    *
FROM
    covid19deaths
LIMIT 5; 

ALTER TABLE covid19deaths
ADD COLUMN new_modified_date DATE;



SET SQL_SAFE_UPDATES = 0;

UPDATE covid19deaths 
SET 
    new_modified_date = STR_TO_DATE(date, '%m/%d/%Y');


SET SQL_SAFE_UPDATES = 1;

DESCRIBE covid19deaths;

SELECT 
    *
FROM
    covid19vaccine
LIMIT 5;

DESCRIBE covid19vaccine;

-- Total location in the chart i.e. 196 country

SELECT 
    COUNT(DISTINCT (location))
FROM
    covid19deaths; 

-- Creating the CTE for easy work.

WITH deathtoll AS (SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid19deaths)
SELECT *
FROM deathtoll;

-- Calculation death over total cases in INDIA and UNITED STATES:

SELECT 
    location,
    date,
    total_deaths,
    total_cases,
    CONCAT(ROUND((total_deaths / total_cases) * 100, 2),
            '%') AS deathPercent
FROM
    covid19deaths
WHERE
    location LIKE '%states%'
        OR location LIKE '%ndia';

-- looking towards the total cases per population in USA and INDIA.
SELECT 
    location,
    date,
    total_cases,
    population,
    CONCAT(ROUND((total_cases / population) * 100, 2),
            '%') AS casePercent
FROM
    covid19deaths
WHERE
    location LIKE '%ndia'
        OR location LIKE '%states%';

-- looking towards the total cases per population over the world.
SELECT 
    location,
    date,
    total_cases,
    population,
    CONCAT(ROUND((total_cases / population) * 100, 2),
            '%') AS casePercent
FROM
    covid19deaths
WHERE
    location LIKE '%ndia'
        OR location LIKE '%states%';


-- HERE we are going to look towards the Highest infection by covid in world wide over population.

SELECT 
    location,
    population,
    MAX(total_cases) AS HighestInfection,
    ROUND((MAX(total_cases) / population) * 100, 2) AS InfectionPercentage
FROM
    covid19deaths
GROUP BY location , population
ORDER BY InfectionPercentage DESC;


-- HERE we are going to look towards the Highest death by covid in world wide over population.

SELECT 
    location,
    population,
    MAX(total_deaths) AS MaxDeath,
    ROUND((MAX(Total_deaths) / population) * 100,
            2) AS DeathPercent
FROM
    covid19deaths
GROUP BY location , population
ORDER BY DeathPercent DESC;

-- Based on the total deaths:
SELECT 
    location,
    population,
    CAST(MAX(total_deaths) AS UNSIGNED) AS MaxDeath,
    ROUND((MAX(Total_deaths) / population) * 100,
            2) AS DeathPercent
FROM
    covid19deaths
GROUP BY location , population
ORDER BY MaxDeath DESC;


-- We are going to look into the stats based on the continent level.

SELECT 
    continent,
    MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM
    covid19deaths
WHERE
    continent IS NOT NULL
        AND continent != ''
GROUP BY continent
ORDER BY TotalDeathCount DESC;


SELECT 
    location,
    MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM
    covid19deaths
WHERE
    continent IS NULL OR continent = ''
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Showing the continent with the highest death count per population

SELECT 
    continent,
    MAX(ROUND(CAST(total_deaths AS UNSIGNED) / NULLIF(population, 0) * 100,
            2)) AS DeathPerPopulation
FROM
    covid19deaths
WHERE
    continent IS NOT NULL
        AND continent <> ''
GROUP BY continent
ORDER BY DeathPerPopulation DESC;

-- Counting deaths on the continent level:

WITH Country_max AS (
SELECT continent, location, MAX(CAST(total_deaths AS UNSIGNED)) AS Max_death
FROM covid19deaths
WHERE location IS NOT NULL
AND TRIM(location) <>''
GROUP BY location, continent
)

SELECT 
    continent, SUM(Max_death) AS Continental_death
FROM
    Country_max
WHERE
    continent IS NOT NULL
        AND TRIM(continent) <> ''
GROUP BY continent
ORDER BY Continental_death;


-- Here we get the overall world level data of percentage death

SELECT 
    SUM(World_Death) AS Total_Death_in_world,
    SUM(World_population) AS Total_Population_World,
    SUM(World_Infection) AS Total_Infection_world
FROM
    (SELECT 
        MAX(CAST(total_deaths AS UNSIGNED)) AS World_Death,
            MAX(population) AS World_population,
            MAX(total_cases) AS World_Infection
    FROM
        covid19deaths
    WHERE
        continent IS NOT NULL
            AND continent <> ''
    GROUP BY location) AS Country_level;
    
    
    
    
#############################################################################################

-- Here we are going the data of the total vaccination in the world level. 
SHOW DATABASES;

USE COVID_19;
SHOW TABLES;

-- Here we see the details of the column and its type.

DESCRIBE covid19vaccine;

-- 'iso_code','text','YES','',NULL,''
-- 'continent','text','YES','',NULL,''
-- 'location','text','YES','',NULL,''
-- 'date','text','YES','',NULL,''
-- 'new_tests','text','YES','',NULL,''
-- 'total_tests','text','YES','',NULL,''
-- 'total_tests_per_thousand','text','YES','',NULL,''
-- 'new_tests_per_thousand','text','YES','',NULL,''
-- 'new_tests_smoothed','text','YES','',NULL,''
-- 'new_tests_smoothed_per_thousand','text','YES','',NULL,''
-- 'positive_rate','text','YES','',NULL,''
-- 'tests_per_case','text','YES','',NULL,''
-- 'tests_units','text','YES','',NULL,''
-- 'total_vaccinations','text','YES','',NULL,''
-- 'people_vaccinated','text','YES','',NULL,''
-- 'people_fully_vaccinated','text','YES','',NULL,''
-- 'new_vaccinations','text','YES','',NULL,''
-- 'new_vaccinations_smoothed','text','YES','',NULL,''
-- 'total_vaccinations_per_hundred','text','YES','',NULL,''
-- 'people_vaccinated_per_hundred','text','YES','',NULL,''
-- 'people_fully_vaccinated_per_hundred','text','YES','',NULL,''
-- 'new_vaccinations_smoothed_per_million','text','YES','',NULL,''
-- 'stringency_index','double','YES','',NULL,''
-- 'population_density','double','YES','',NULL,''
-- 'median_age','double','YES','',NULL,''
-- 'aged_65_older','double','YES','',NULL,''
-- 'aged_70_older','double','YES','',NULL,''
-- 'gdp_per_capita','double','YES','',NULL,''
-- 'extreme_poverty','text','YES','',NULL,''
-- 'cardiovasc_death_rate','double','YES','',NULL,''
-- 'diabetes_prevalence','double','YES','',NULL,''
-- 'female_smokers','text','YES','',NULL,''
-- 'male_smokers','text','YES','',NULL,''
-- 'handwashing_facilities','double','YES','',NULL,''
-- 'hospital_beds_per_thousand','double','YES','',NULL,''
-- 'life_expectancy','double','YES','',NULL,''
-- 'human_development_index','double','YES','',NULL,''


SELECT 
    *
FROM
    covid19vaccine
LIMIT 15;


-- Joining both the table for wide range of data in a table, we join on the base of location and date. 

SELECT 
    *
FROM
    covid19deaths AS dea
        JOIN
    covid19vaccine AS vac ON dea.location = vac.location
        AND dea.date = vac.date;


-- Total population vs new_vaccination:

SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations
FROM
    covid19deaths AS dea
        JOIN
    covid19vaccine AS vac ON dea.date = vac.date
        AND dea.location = vac.location
WHERE
    dea.continent IS NOT NULL
        AND dea.continent <> ''
ORDER BY 2 , 3;

-- Total vaccination side by side in new column.
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER(PARTITION BY dea.location) AS running_total
FROM
    covid19deaths AS dea
        JOIN
    covid19vaccine AS vac ON dea.date = vac.date
        AND dea.location = vac.location
WHERE
    dea.continent IS NOT NULL
        AND dea.continent <> ''
ORDER BY 2 , 3;

-- Done with the CTE(Complex Table Expression). CTE is table which is limited to that code only, Its main purpose is to
-- make a query simpler and we can perform the operation over CTE.

WITH vaccination_count AS (
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS UNSIGNED)) 
        OVER(
            PARTITION BY dea.location 
            ORDER BY STR_TO_DATE(dea.date,'%m/%d/%Y')
        ) AS running_total
FROM covid19deaths AS dea
JOIN covid19vaccine AS vac 
     ON dea.date = vac.date
    AND dea.location = vac.location
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, STR_TO_DATE(dea.date,'%m/%d/%Y'))

SELECT * FROM vaccination_count;


-- Creating a VIEW Table, so that it can permanently serve the user. It gets update on the real time. This stores query 
-- not the table, so any change in the table beneath made the update on VIEW.

CREATE VIEW VaccinationOverPopulation AS
SELECT (MAX(total_vaccine) /population)*100 AS vaccine_percent
FROM
(SELECT dea.continent, dea.location, dea.date, dea.population, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location) AS total_vaccine
FROM covid19deaths AS dea
JOIN covid19vaccine AS vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent <> '') AS t;
    
    
    
    