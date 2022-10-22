DROP TABLE public.dimDate CASCADE;
DROP TABLE public.dimRider CASCADE;
DROP TABLE public.dimStation CASCADE;
DROP TABLE public.factPayment CASCADE;
DROP TABLE public.factTrip CASCADE;


create table dimDate (
    id date primary key,
    dayofweek int,
    weekofyear int,
    month int,
    dayofmonth int,
    year int
);

create table dimStation (
    id serial primary key,
    name varchar(40),
    latitude float,
    longitute float
);

create table dimRider (
    id serial primary key,
    first_name varchar(40) not null,
    family_name varchar(40) not null,
    birthday date not null,
    email varchar(256) not null unique,
    account_start date not null,
    account_end date not null
);

create table factPayment (
    id serial primary key,
    amount money not null,
    date date references dimDate(id),
    rider int references dimRider(id),
    start_station int references dimStation(id),
    end_station int references dimStation(id)
);

create table factTrip (
    id serial primary key,
    start_date date references dimDate(id),
    start_time time,
    duration int,
    start_station int references dimStation(id),
    end_station int references dimStation(id),
    rideable_type varchar,
    spent int references factPayment(id),
    rider int references dimRider(id),
    rider_age int not null,
    is_member bool not null
    );

