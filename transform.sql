-- transform divvy staging data into STAR schema 

-- dimStation 
DROP TABLE dimStation
CREATE TABLE dimStation(
    id NVARCHAR (50) PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    name NVARCHAR (100),
    latitude FLOAT,
    longitude FLOAT
)
GO

INSERT INTO dimStation (id, name, latitude, longitude)
SELECT id, name, latitude, longitude
FROM station

SELECT TOP 10 * FROM dimStation

-- dimRider 
DROP TABLE dimRider
CREATE TABLE dimRider(
    id int PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    first varchar(50),
    last varchar(50),
    birthdate date,
    account_start date,
    account_end date,
    is_member bit
)

INSERT INTO dimRider (id, first, last, birthdate, 
                      account_start, account_end, is_member)
SELECT id, first, last, TRY_CONVERT(DATE, birthdate) as birthdate,
       start_date, end_date, is_member
FROM rider

SELECT TOP 10 * from dimRider

-- dimDate 
DROP TABLE dimDate
CREATE TABLE dimDate(
    id date PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    dayofweek int,
    dayofmonth int,
    weekofyear int,
    month int,
    quarter int,
    year int
)

INSERT INTO dimDate (id)
SELECT TRY_CONVERT(DATE, LEFT(started_at, 10)) as id
FROM trip

INSERT INTO dimDate (id)
SELECT TRY_CONVERT(DATE, date) as id
FROM payment

SELECT TOP 10 * from dimDate

-- factPayment
DROP TABLE factPayment
CREATE TABLE factPayment(
    id int PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    amount money, 
    date date,
    member bit,
    startstation varchar(50),
    endstation varchar(50),
    rider_id int
)

-- factTrip
DROP TABLE factTrip


