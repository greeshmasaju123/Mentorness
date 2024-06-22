 --Imported the csv data file into mysql workbench after creating the database corona and imported the csv file by right clicking on the database corona and clicked on "table data import wizard"
 --then the dataset got imported

-- Q1 Write a code to check NULL values
Select * FROM corona.corona_virus
WHERE Province IS NULL
   OR `Country/Region` IS NULL
   OR Latitude IS NULL
   OR Longitude IS NULL
   OR Date IS NULL
   OR Confirmed IS NULL
   OR Deaths IS NULL
   OR Recovered IS NULL;
SET SQL_SAFE_UPDATES = 0;

-- Q2  If NULL values are present, update them with zeros for all columns.
SET SQL_SAFE_UPDATES = 0;

UPDATE corona.corona_virus
SET 
    Province = COALESCE(`Province`, '0'),
    `Country/Region` = COALESCE(`Country/Region`, '0'),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    Date = COALESCE(Date, '0'),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);

-- Q3 check total number of rows
select count(*) as total_rows  from corona.corona_virus; 

-- Q4 Check what is start_date and end_date
SELECT
    (SELECT MIN(Date) FROM corona.corona_virus) AS start_date,
    (SELECT MAX(Date) FROM corona.corona_virus) AS end_date;

-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m')) AS num_months
FROM corona.corona_virus;

-- Q6 Find monthly average for confirmed, deaths, recovered
SELECT 
    DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS month,
    AVG(Confirmed) AS avg_confirmed,
    AVG(Deaths) AS avg_deaths,
    AVG(Recovered) AS avg_recovered
FROM corona.corona_virus group by month;

-- Q7 
-- Most frequent confirmed cases per month
SELECT 
    month,
    (SELECT Confirmed 
     FROM corona.corona_virus
     WHERE DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') = t.month 
     GROUP BY Confirmed 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS mode_confirmed,
    (SELECT Deaths 
     FROM corona.corona_virus 
     WHERE DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') = t.month 
     GROUP BY Deaths 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS mode_deaths,
    (SELECT Recovered 
     FROM corona.corona_virus 
     WHERE DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') = t.month 
     GROUP BY Recovered 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS mode_recovered
FROM (
    SELECT DISTINCT DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS month
    FROM corona.corona_virus
) AS t
ORDER BY month;


-- Q8 Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM corona.corona_virus
GROUP BY year
ORDER BY year;



-- Q9 Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM corona.corona_virus
GROUP BY YEAR(STR_TO_DATE(Date, '%d-%m-%Y'));

-- Q10  The total number of case of confirmed, deaths, recovered each month
SELECT 
    DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM corona.corona_virus
GROUP BY DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m');

-- Q11 Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

-- Total confirmed cases
SELECT 
    sum(Confirmed) AS total_confirmed_cases,
    AVG(Confirmed) AS average_confirmed_cases,
    VARIANCE(Confirmed) AS variance_confirmed_cases,
    STDDEV(Confirmed) AS stdev_confirmed_cases
FROM corona.corona_virus;

-- Q12 Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS month,
    SUM(Deaths) AS total_death_cases,
    AVG(Deaths) AS average_death_cases,
    VARIANCE(Deaths) AS variance_death_cases,
    STDDEV(Deaths) AS stdev_death_cases
FROM corona.corona_virus
GROUP BY DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m');

-- Q13  Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS month,
    SUM(Recovered) AS total_recovered_cases,
    AVG(Recovered) AS average_recovered_cases,
    VARIANCE(Recovered) AS variance_recovered_cases,
    STDDEV(Recovered) AS stdev_recovered_cases
FROM corona.corona_virus
GROUP BY DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m');

-- Q14  Find Country having highest number of the Confirmed case
SELECT 
    `Country/Region`,
    sum(Confirmed) AS highest_confirmed_cases
FROM corona.corona_virus
GROUP BY `Country/Region`
ORDER BY highest_confirmed_cases DESC
LIMIT 1;

-- Q15 Find Country having lowest number of the death case
SELECT 
    `Country/Region`,
    sum(Deaths) AS min_death_cases
FROM corona.corona_virus
GROUP BY `Country/Region`
ORDER BY min_death_cases ASC
LIMIT 1;

-- Q16 Find top 5 countries having highest recovered case
SELECT 
    `Country/Region` AS Country,
    SUM(Recovered) AS total_recovered_cases
FROM corona.corona_virus
GROUP BY `Country/Region`
ORDER BY total_recovered_cases DESC
LIMIT 5;











