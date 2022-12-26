DROP TABLE IF EXISTS powerplants CASCADE;
DROP TABLE IF EXISTS fuels;
DROP TABLE IF EXISTS owners;

CREATE TABLE Owners(
	owner_id   SERIAL PRIMARY KEY,
	owner_name VARCHAR(255)
);

CREATE TABLE Fuels(
	fuel_id   SERIAL PRIMARY KEY,
	fuel_name VARCHAR(50)
);

CREATE TABLE Powerplants(
	id         VARCHAR(12) PRIMARY KEY,
	name       VARCHAR(255) NOT NULL,
	country    VARCHAR(255),
	capacity   NUMERIC CONSTRAINT positive_capacity CHECK (capacity > 0),
	latitude   NUMERIC CONSTRAINT range_latitude CHECK (latitude > -90 and latitude < 90),
	longtitude NUMERIC CONSTRAINT range_longtitude CHECK (longtitude > -180 and longtitude < 180),
	owner      INT REFERENCES Owners(owner_id) ON DELETE CASCADE,
	fuel_type  INT REFERENCES Fuels(fuel_id) ON DELETE RESTRICT
);