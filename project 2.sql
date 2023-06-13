create database project;
use project;
drop table flight;
create table flight(
YEAR int,
MONTH int,
DAY int,
DAY_OF_WEEK int,
AIRLINE varchar(50),
FLIGHT_NUMBER int,
TAIL_NUMBER varchar(50),
ORIGIN_AIRPORT varchar(10),
DESTINATION_AIRPORT varchar(10),
SCHEDULED_DEPARTURE int,
DEPARTURE_TIME varchar(10),
DEPARTURE_DELAY varchar(10),
TAXI_OUT varchar(10),
WHEELS_OFF varchar(10),
SCHEDULED_TIME varchar(10),
ELAPSED_TIME varchar(10),
AIR_TIME varchar(10),
DISTANCE varchar(10),
WHEELS_ON varchar(10),
TAXI_IN varchar(10),
SCHEDULED_ARRIVAL varchar(10),
ARRIVAL_TIME varchar(10),
ARRIVAL_DELAY varchar(10),
DIVERTED BINARY,
CANCELLED BINARY,
CANCELLATION_REASON Varchar(50),
AIR_SYSTEM_DELAY varchar(10),
SECURITY_DELAY varchar(10),
AIRLINE_DELAY varchar(10),
LATE_AIRCRAFT_DELAY varchar(10),
WEATHER_DELAY varchar(10)
);

select count(*) from flight;
USE PROJECT;
LOAD DATA INFILE "C:/ProgramData/MySQL/flights.csv" INTO TABLE flight
FIELDS TERMINATED BY ','
IGNORE 1 LINES;


select count(*) from flight;

show table status from project;
drop table airports;
select count(*) from airports;



DROP TABLE AIRPORTS;
create table airports(
IATA_CODE varchar(5),
AIRPORT VARCHAR(80),
CITY VARCHAR(50),
STATE VARCHAR(50),
COUNTRY VARCHAR(50),
LATITUDE DOUBLE DEFAULT 0,
LONGITUDE DOUBLE DEFAULT 0
);
LOAD DATA INFILE "C:/ProgramData/MySQL/airports.csv" INTO TABLE airports
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

-- KPI 1
SELECT
       CASE 
           WHEN DAY_OF_WEEK IN (6,7) THEN 'Weekend' 
           ELSE 'Weekday' 
       END AS DayType, 
       COUNT(*) AS TotalFlights
FROM flight
Group By DayType
ORDER BY DayType;


-- KPI 2
SELECT COUNT(*) AS TotalCancelledFlights
FROM flight
WHERE AIRLINE = 'B6' AND DAY = 1 AND CANCELLED = 1;


-- KPI 4
SELECT COUNT(DISTINCT AIRLINE) AS Num_Airlines
FROM flight f
JOIN airports a1 ON f.ORIGIN_AIRPORT = a1.IATA_CODE
JOIN airports a2 ON f.DESTINATION_AIRPORT = a2.IATA_CODE
WHERE DISTANCE BETWEEN 2500 AND 3000
AND f.DEPARTURE_DELAY = 0
AND f.ARRIVAL_DELAY = 0;


-- KPI 3
SELECT 
  DAY_OF_WEEK, 
  COUNT(*) AS TotalFlights, 
  COUNT(CASE WHEN DEPARTURE_DELAY > 0 THEN 1 END) AS DelayedFlights, 
  AVG(DEPARTURE_DELAY) AS AverageDelay 
FROM flight 
join airports ON flight.ORIGIN_AIRPORT = airports.IATA_CODE 
JOIN airlines ON flight.AIRLINE = airlines.IATA_CODE
GROUP BY DAY_OF_WEEK
ORDER BY DAY_OF_WEEK;