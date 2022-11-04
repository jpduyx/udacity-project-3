-- Fact Tables
-- transform divvy staging data into STAR schema


-- factTrip
-- TODO make SQL for
   -- rider age at time of trip 
   -- SELECT DATEDIFF(year, 'trip start date', 'birthday') AS rider_age;
   -- rider is member at time of trip ? -> DATEDIFF() 
DROP TABLE IF EXISTS factTrip;
CREATE TABLE factTrip(
    id VARCHAR(40) PRIMARY KEY, --NONCLUSTERED NOT ENFORCED
    start_at DATETIME,
    ended_at DATETIME,
    duration TIME,
    startstation VARCHAR(50),
    endstation VARCHAR(50),
    rideable_type VARCHAR(15),
    rider INT,
    rider_age INT,
    is_member BIT
);


insert into factTrip(id, start_at, ended_at, startstation, endstation, 
                    rideable_type, rider)
select id, 
       TRY_CONVERT(datetime, left(start_at, 19)) as start_at, 
       TRY_CONVERT(datetime, left(ended_at, 19)) as ended_at,
       startstation, endstation, rideable_type,  rider_id
from trip;

UPDATE factTrip SET duration = (ended_at - start_at);
UPDATE factTrip SET rider_age = datediff (year, r.birthday, t.start_at)
from factTrip t LEFT JOIN rider r ON r.id = t.rider;

select TOP 10 * from factTrip;


-- factPayment
DROP TABLE IF EXISTS factPayment
CREATE TABLE factPayment(
    id INT PRIMARY KEY, --NONCLUSTERED NOT ENFORCED
    amount FLOAT,
    date DATE,
    rider INT
);

INSERT INTO factPayment(id, amount, date, rider)
select id, amount, date, rider
from payment;

select TOP 10 * from factPayment;
