-- transform divvy staging data into STAR schema 

-- dimStation 
DROP TABLE dimStation
CREATE TABLE dimStation(
    id VARCHAR (50) PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    name VARCHAR (100),
    latitude FLOAT,
    longitude FLOAT
);

INSERT INTO dimStation (id, name, latitude, longitude)
SELECT id, name, latitude, longitude
FROM station;

SELECT TOP 10 * FROM dimStation;

-- dimRider 
DROP TABLE dimRider
CREATE TABLE dimRider(
    id INT PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    first VARCHAR(50),
    last VARCHAR(50),
    birthdate DATE,
    account_start DATE,
    account_end DATE,
    is_member bit
);

INSERT INTO dimRider (id, first, last, birthdate, 
                      account_start, account_end, is_member)
SELECT id, first, last, TRY_CONVERT(DATE, birthdate) as birthdate,
       start_date, end_date, is_member
FROM rider;

SELECT TOP 10 * from dimRider;

-- dimDate 
DROP TABLE dimDate;
CREATE TABLE dimDate(
    ts DATETIME PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    hour INT,
    dayofweek INT,
    dayofmonth INT,
    weekofyear INT,
    quarter INT,
    month INT,
    year INT
);

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
SET @StartDate = (SELECT MIN(TRY_CONVERT(datetime, left(start_at, 19))) FROM trip)
SET @EndDate = DATEADD(month, 6, (SELECT MAX(TRY_CONVERT(datetime, left(start_at, 19))) FROM trip))

WHILE @StartDate <= @EndDate
      BEGIN
             INSERT INTO [dimDate]
             SELECT
                   @StartDate,
                   DATEPART(HOUR, @StartDate),
                   DATEPART(WEEKDAY, @StartDate),
                   DATEPART(DAY, @StartDate),
                   DATEPART(WEEK, @StartDate),
                   DATEPART(QUARTER, @StartDate),
                   DATEPART(MONTH, @StartDate),
                   DATEPART(YEAR, @StartDate)

             SET @StartDate = DATEADD(dd, 1, @StartDate)
      END;

select TOP 100 * from dimDate;

