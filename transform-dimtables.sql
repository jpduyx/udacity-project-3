-- Dimension Tables
-- transform divvy staging data into STAR schema 

-- dimStation 
DROP TABLE IF EXISTS dimStation;
CREATE TABLE dimStation(
    id VARCHAR (50) PRIMARY KEY, -- NONCLUSTERED NOT ENFORCED,
    name VARCHAR (150),
    latitude FLOAT,
    longitude FLOAT
);

INSERT INTO dimStation (id, name, latitude, longitude)
SELECT id, name, latitude, longitude
FROM station;

SELECT TOP 10 * FROM dimStation;

-- dimRider 
DROP TABLE IF EXISTS dimRider;
CREATE TABLE dimRider(
    id INT PRIMARY KEY, -- NONCLUSTERED NOT ENFORCED,
    first VARCHAR(40),
    last VARCHAR(40),
    birthday DATE,
    address VARCHAR(40),
    account_start DATE,
    account_end DATE,
    is_member BIT
);

INSERT INTO dimRider (id, first, last, birthday, address,
                      account_start, account_end, is_member)
SELECT id, first, last, TRY_CONVERT(DATE, birthday) as birthday,
       address, account_start, account_end, is_member
FROM rider;

SELECT TOP 10 * from dimRider;

-- dimDate
DROP TABLE IF EXISTS dimDate;
CREATE TABLE dimDate(
    id DATETIME PRIMARY KEY, -- NONCLUSTERED NOT ENFORCED,
    hour INT,
    dayofweek INT,
    dayofmonth INT,
    weekofyear INT,
    month INT,
    quarter INT,
    year INT
);

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
SET @StartDate = (SELECT MIN(TRY_CONVERT(datetime, left(start_at, 13))) FROM trip)
SET @EndDate = DATEADD(month, 6, (SELECT MAX(TRY_CONVERT(datetime, left(ended_at, 13))) FROM trip))

WHILE @StartDate <= @EndDate
      BEGIN
             INSERT INTO [dimDate]
             SELECT
                   @StartDate,
                   DATEPART(hh, @StartDate),
                   DATEPART(WEEKDAY, @StartDate),
                   DATEPART(DAY, @StartDate),
                   DATEPART(WEEK, @StartDate),
                   DATEPART(MONTH, @StartDate),                   
                   DATEPART(QUARTER, @StartDate),
                   DATEPART(YEAR, @StartDate)

             SET @StartDate = DATEADD(hh, 1, @StartDate)
      END;

select TOP 100 * from dimDate;

