/* Use MySql Command Line for quickly loading data and queries */

create database if not exists accidents;

USE accidents;

/* -------------------------------- */
/* Create Tables */
CREATE TABLE accident(
	accident_index VARCHAR(13),
    accident_severity INT
);

CREATE TABLE vehicles(
	accident_index VARCHAR(13),
    vehicle_type VARCHAR(50)
);

/* First: for vehicle types, create new csv by extracting data from Vehicle Type sheet from Road-Accident-Safety-Data-Guide.xls */
CREATE TABLE vehicle_types(
	vehicle_code INT,
    vehicle_type VARCHAR(10)
);


/* -------------------------------- */
/* Load Data */
/* Load data in MySQL command line it is very quick */

LOAD DATA LOCAL INFILE "D:/SHUBHAM 19/FSDA Assignments/Assignment 2/Accidents_2015.csv"
INTO TABLE accident
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, accident_severity=@col2;

select * from accident limit 5;
select count(*) from accident;

LOAD DATA LOCAL INFILE "D:/SHUBHAM 19/FSDA Assignments/Assignment 2/Vehicles_2015.csv"
INTO TABLE vehicles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, vehicle_type=@col2;

select * from vehicles limit 5;
select count(*) from vehicles;

LOAD DATA LOCAL INFILE "D:/SHUBHAM 19/FSDA Assignments/Assignment 2/vehicle_types.csv"
INTO TABLE vehicle_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select * from vehicle_types limit 5;
select count(*) from vehicle_types;
/* -------------------------------- */

/* SIDE NOTE: Compare performance of the query rows by using Explain Icon first (Before Indexing and After Indexing)*/

/* Create index on accident_index as it is using in both vehicles and accident tables and join clauses using indexes will perform faster */
CREATE INDEX accident_index
ON accident(accident_index);

CREATE INDEX accident_index
ON vehicles(accident_index);


/* get Accident Severity and Total Accidents per Vehicle Type */
SELECT vt.vehicle_type AS 'Vehicle Type', a.accident_severity AS 'Severity', COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2,3;

/* Average Severity by vehicle type */
SELECT vt.vehicle_type AS 'Vehicle Type', AVG(a.accident_severity) AS 'Average Severity', COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2,3;


/* Average Severity and Total Accidents by Motorcyle */
SELECT vt.vehicle_type AS 'Vehicle Type', AVG(a.accident_severity) AS 'Average Severity', COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
WHERE vt.vehicle_type LIKE '%otorcycle%'
GROUP BY 1
ORDER BY 2,3;

/* ------------------------------------------------------------------------------------------------------------------------*/
CREATE database ca_population;

USE ca_population;

CREATE TABLE pop_proj(
county_code VARCHAR(45) NOT NULL,
county_name VARCHAR(45) NOT NULL,
date_year INT NOT NULL,
race_code INT NOT NULL,
race TEXT NOT NULL,
gender VARCHAR(6) NOT NULL,
age INT NOT NULL,
population INT NOT NULL
);

/* Load Data */
/* ignore first header line, delimiter setting, etc*/
LOAD DATA LOCAL INFILE "D:/SHUBHAM 19/FSDA Assignments/CA_DRU_proj_2010-2060/CA_DRU_proj_2010-2060.csv"
INTO TABLE pop_proj
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* check the loaded data */
SELECT * FROM pop_proj LIMIT 10;

/* Which country has the highest population?*/
SELECT county_name, SUM(population) AS TotalPopulation FROM pop_proj
GROUP BY county_name
ORDER BY TotalPopulation DESC
LIMIT 1;

/* Which country has the least number of people?*/
SELECT county_name, SUM(population) AS TotalPopulation FROM pop_proj
GROUP BY county_name
ORDER BY TotalPopulation ASC
LIMIT 1;

/* Which country is witnessing the highest population growth?*/
SELECT county_name, MAX(population - LagPopulation) AS PopulationGrowth
FROM (SELECT county_name, population,
LAG(population) OVER (PARTITION BY county_name ORDER BY date_year) AS LagPopulation FROM pop_proj) AS PopulationData
GROUP BY county_name
ORDER BY PopulationGrowth DESC
LIMIT 1;

/* Which country has an extraordinary number for the population?*/
SELECT county_name, population FROM pop_proj
ORDER BY ABS(population) DESC
LIMIT 1;

/* Which is the most densely populated country in the world?*/
SELECT county_name, AVG(population) AS AveragePopulation,
COUNT(DISTINCT date_year) AS NumberOfYears,
AVG(population) / COUNT(DISTINCT date_year) AS AveragePopulationPerYear
FROM pop_proj
GROUP BY county_name
ORDER BY AveragePopulationPerYear DESC
LIMIT 1;
