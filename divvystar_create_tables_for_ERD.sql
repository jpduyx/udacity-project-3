-- star.dimdate definition

CREATE TABLE star.dimdate (
	"ts" timestamp NOT NULL,
    "hour" int4 NULL,
	"dayofweek" int4 NULL,
	"dayofmonth" int4 NULL,
	"weekofyear" int4 NULL,
	"month" int4 NULL,
	"quarter" int4 NULL,
	"year" int4 NULL,

	CONSTRAINT dimdate_pkey PRIMARY KEY (ts)
);


-- star.dimrider definition

CREATE TABLE star.dimrider (
	"id" serial4 NOT NULL,
	"first" varchar(40) NOT NULL,
	"last" varchar(40) NOT NULL,
	"birthday" date NOT NULL,
--	"email" varchar(256) NOT NULL,
	"account_start" date NOT NULL,
	"account_end" date NOT NULL,
    "is_member" bit,
--	CONSTRAINT dimrider_email_key UNIQUE (email),
	CONSTRAINT dimrider_pkey PRIMARY KEY (id)
);


-- star.dimstation definition

CREATE TABLE star.dimstation (
	"id" serial4 NOT NULL,
	"name" varchar(40) NULL,
	"latitude" float8 NULL,
	"longitute" float8 NULL,
	CONSTRAINT dimstation_pkey PRIMARY KEY (id)
);


-- star.factpayment definition

CREATE TABLE star.factpayment (
	"id" serial4 NOT NULL,
	"amount" money NOT NULL,
	"date" date NULL,
	"rider" int4 NULL,
	"start_station" int4 NULL,
	"end_station" int4 NULL,
	CONSTRAINT factpayment_pkey PRIMARY KEY (id),
	CONSTRAINT factpayment_date_fkey FOREIGN KEY ("date") REFERENCES star.dimdate(ts),
	CONSTRAINT factpayment_end_station_fkey FOREIGN KEY (end_station) REFERENCES star.dimstation(id),
	CONSTRAINT factpayment_rider_fkey FOREIGN KEY (rider) REFERENCES star.dimrider(id),
	CONSTRAINT factpayment_start_station_fkey FOREIGN KEY (start_station) REFERENCES star.dimstation(id)
);


-- star.facttrip definition

CREATE TABLE star.facttrip (
	"id" serial4 NOT NULL,
	"start_at" timestamp NULL,
    "ended_at" timestamp NULL,
	"duration" int4 NULL,
	"start_station" int4 NULL,
	"end_station" int4 NULL,
	"rideable_type" varchar NULL,
--	  "amount" int4 NULL,
	"rider" int4 NULL,
	"rider_age" int4 NOT NULL,
	"is_member" bool NOT NULL,

	CONSTRAINT facttrip_pkey PRIMARY KEY (id),
	CONSTRAINT facttrip_end_station_fkey FOREIGN KEY (end_station) REFERENCES star.dimstation(id),
	CONSTRAINT facttrip_rider_fkey FOREIGN KEY (rider) REFERENCES star.dimrider(id),
--	CONSTRAINT facttrip_amount_fkey FOREIGN KEY (amount) REFERENCES star.factpayment(id),
	CONSTRAINT facttrip_start_date_fkey FOREIGN KEY (start_at) REFERENCES star.dimdate(ts),
	CONSTRAINT facttrip_start_station_fkey FOREIGN KEY (start_station) REFERENCES star.dimstation(id)
);
