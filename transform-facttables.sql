-- factPayment
DROP TABLE factPayment
CREATE TABLE factPayment(
    id INT PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    amount MONEY,
    date DATE,
--    member BIT,
--    startstation VARCHAR(50),
--    endstation VARCHAR(50),
    rider_id INT
);

INSERT INTO factPayment(id, amount, date, rider_id)
select id, amount, date, id
from payment;

-- TODO how to make SQL for
   -- rider is member at time of trip ? trip_date is in range rider.account_start rider.account_end 
   -- getting start and endstation for a payment 

select TOP 10 * from factPayment;


-- factTrip
DROP TABLE factTrip
CREATE TABLE factTrip(
    id VARCHAR(50) PRIMARY KEY NONCLUSTERED NOT ENFORCED,
    start_at DATETIME,
    ended_at DATETIME,
    duration VARCHAR(50),
    startstation VARCHAR(50),
    endstation VARCHAR(50),
    rideable_type VARCHAR(20),
    rider INT
-- TODO
--    rider_age INT,
--    is_member BIT
)

insert into factTrip(id, start_at, ended_at, startstation, endstation, 
                    rideable_type, rider)
select id, 
       TRY_CONVERT(datetime, left(start_at, 19)) as start_at, 
       TRY_CONVERT(datetime, left(ended_at, 19)) as ended_at,
       startstation, endstation, rideable_type,  rider_id
from trip;

UPDATE factTrip SET duration = (ended_at - start_at);

select TOP 10 * from factTrip;

