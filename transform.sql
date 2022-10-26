-- transform divvy staging data into STAR schema 

-- dimStation 
DROP TABLE dimStation
CREATE TABLE dimStation(
    id VARCHAR (50) PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    name VARCHAR (100),
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
    id INT PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    first VARCHAR(50),
    last VARCHAR(50),
    birthdate DATE,
    account_start DATE,
    account_end DATE,
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
    id DATE PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    dayofweek INT,
    dayofmonth INT,
    weekofyear INT,
    month INT,
    quarter INT,
    year INT
)

INSERT INTO dimDate (id)
SELECT TRY_CONVERT(DATE, LEFT(started_at, 10)) as id
FROM trip;

INSERT INTO dimDate (id)
SELECT TRY_CONVERT(DATE, LEFT(ended_at, 10)) as id
FROM trip;

INSERT INTO dimDate (id)
SELECT TRY_CONVERT(DATE, date) as id
FROM payment;

update dimdate 
set dayofweek = (SELECT EXTRACT(DOW FROM dimdate.id)),
    dayofmonth = (select extract(day from dimdate.id)),
    weekofyear = (select extract(WEEK from dimdate.id)),
    month = (select extract(month from dimdate.id)),
    quarter = (select extract(QUARTER from dimdate.id)),
    year = (select extract(year from dimdate.id))
;

select TOP 10 * from dimDate;

-- factPayment
DROP TABLE factPayment
CREATE TABLE factPayment(
    id INT PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    amount MONEY,
    date DATE,
    member BIT,
    startstation VARCHAR(50),
    endstation VARCHAR(50),
    rider_id INT
);
INSERT INTO factPayment(id, amount, date, rider_id)
select id, amount, date, id
from payment

select TOP 10 * from factPayment;

-- factTrip
-- TODO this doesn't work yet ... getting stuck somewhere perhaps time to sleep and try again fresh tomorrow
DROP TABLE factTrip
CREATE TABLE factTrip(
    id VARCHAR(50) PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    startdate DATE,
    starttime TIME,
    duration VARCHAR(50),
    startstation VARCHAR(50),
    endstation VARCHAR(50),
    rideable_type VARCHAR(20),
    rider INT,
    rider_age INT,
    is_member BIT
)

insert into factTrip(id, startdate, starttime, duration, startstation, endstation, rideable_type, 
                     rider)
select id, TRY_CONVERT(DATE, LEFT(started_at, 10)) as startdate, 
           TRY_CONVERT(TIME, RIGHT(started_at, 10)) as starttime,
            ended_at, (ended_at - started_at) as duration, 
       startstation, endstation, rideable_type,  rider_id
from trip
;

select TOP 10 * from factTrip;
