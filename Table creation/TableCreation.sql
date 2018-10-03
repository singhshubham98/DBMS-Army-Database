DROP SCHEMA IF EXISTS armydb CASCADE;
CREATE SCHEMA Armydb;
SET SEARCH_PATH TO Armydb;

-- Medals distributed to soldiers
CREATE TABLE Medal (
name VARCHAR(100) PRIMARY KEY
);

-- cateogry of Weapons
-- class describe the type of the weapons
CREATE TABLE category (
name  VARCHAR(100) PRIMARY KEY,
class VARCHAR(100)
);

-- Weapons Details of the army
CREATE TABLE Weapons (
weapon_id    INTEGER PRIMARY KEY,
name   VARCHAR(100) REFERENCES cateogry(name)
);

-- Each battalian details
-- name represents the name of the battalian
CREATE TABLE battalian (
b_name VARCHAR(100),
Captain_id  INTEGER    NOT NULL,
year   INTEGER 	 NOT NULL,
totalCapacity INTEGER    NOT NULL CHECK (totalCapacity > 0),
PRIMARY KEY(b_name, year)
);

-- General location entity
CREATE TABLE location (
pincode  VARCHAR(6) PRIMARY KEY CHECK (length(pincode) = 6),
district VARCHAR(100) NOT NULL,
state    VARCHAR(100) NOT NULL,
country  VARCHAR(100) NOT NULL,
UNIQUE (pincode)
);

CREATE TABLE company (
company_name VARCHAR(100) PRIMARY KEY,
country_name VARCHAR(100) NOT NULL
);

-- Manufacturing details of the weapon
CREATE TABLE Manufacturing_details (
weapon_id   INTEGER REFERENCES weapons (weapon_id)
ON UPDATE CASCADE ON DELETE CASCADE,
Manufaturing_date DATE NOT NULL,
Manufacturing_location VARCHAR(100),
company_name VARCHAR(100) NOT NULL REFERENCES company(company_name),
PRIMARY KEY(weapon_id, company_name)
);

-- Soldier Entity (Prime)
-- DOJ (Date of joining)
-- DOR (Date of retirement)
-- DOB (Date of Birth)
-- RANK is the rank at the time of posting
CREATE TABLE Soldier (
id          INTEGER NOT NULL,
name               VARCHAR(100) NOT NULL,
rank               VARCHAR(30) NOT NULL,
doj                DATE NOT NULL,
dob		   DATE NOT NULL,
dor		   DATE NOT NULL,
b_name            VARCHAR(100) NOT NULL,
year            INTEGER NOT NULL,
birthplacepincode  VARCHAR(6) NOT NULL REFERENCES Location(pincode)
ON UPDATE CASCADE ON DELETE CASCADE,
sex         INTEGER NOT NULL CHECK (SEX = 1 OR SEX = 0),
height INTEGER CHECK (Height > 152),
weight INTEGER CHECK (Weight > 50),
chest  INTEGER CHECK (Chest > 52),
UNIQUE (id),
FOREIGN KEY (b_name, year) REFERENCES squads(b_name, year),
PRIMARY KEY (id, b_name,year, birthplacepincode)
);

-- Places Visited by Soldier
CREATE TABLE Visited (
sold_id      INTEGER NOT NULL,
pincode VARCHAR(6) NOT NULL,
date DATE NOT NULL,
Reason  VARCHAR(100) NOT NULL,
PRIMARY KEY (sold_id, pincode, date),
FOREIGN KEY (sold_id) REFERENCES Soldier(id)
ON UPDATE CASCADE ON DELETE CASCADE
);

-- War Catalog
-- Details of each war that has taken place
-- 0 from win
-- 1 for lost
-- 2 for undecisive
CREATE TABLE war (
pincode VARCHAR(6) NOT NULL REFERENCES Location (pincode)
ON UPDATE CASCADE ON DELETE CASCADE,
status  INTEGER NOT NULL CHECK (Status = 0 OR Status = 1 OR Status = 2),
date    INTEGER    NOT NULL,
UNIQUE(date),
PRIMARY KEY (pincode, date)
);

-- Work Type
CREATE TABLE work (
type   VARCHAR(100) PRIMARY KEY,
salary INTEGER NOT NULL
);

-- Work assigned to soldier
CREATE TABLE assign (
sold_id   INTEGER NOT NULL REFERENCES Soldier (id)
ON UPDATE CASCADE ON DELETE CASCADE,
type VARCHAR(100) NOT NULL REFERENCES work(type)
ON UPDATE CASCADE ON DELETE CASCADE,
Date DATE NOT NULL,
PRIMARY KEY (sold_id, type)
);

-- Soldier status on a particular date
CREATE TABLE SoldierStatus (
sold_id    INTEGER NOT NULL REFERENCES Soldier(id)
ON UPDATE CASCADE ON DELETE CASCADE,
alive       INTEGER NOT NULL,
wardate INTEGER NOT NULL,
pincode VARCHAR(6) NOT NULL,
FOREIGN KEY (wardate, pincode) REFERENCES war(date, pincode)
ON UPDATE CASCADE ON DELETE CASCADE,
PRIMARY KEY (sold_id, wardate, pincode),
UNIQUE(sold_id, wardate, pincode)
);


-- Place where posting of the soldier has happened
CREATE TABLE posting (
sold_id INTEGER NOT NULL  REFERENCES soldier(id),
pincode VARCHAR(6) NOT NULL REFERENCES location(pincode),
date DATE NOT NULL,
PRIMARY KEY (sold_id, pincode, date)
);

-- Reward gained by the soldier
CREATE TABLE reward (
sold_id      INTEGER NOT NULL REFERENCES soldier (id)
ON UPDATE CASCADE ON DELETE CASCADE,
medalname VARCHAR(100) NOT NULL REFERENCES medal (name)
ON UPDATE CASCADE ON DELETE CASCADE,
Year      INTEGER NOT NULL,
PRIMARY KEY (sold_id, medalname)
);

-- Inventory of each soldier
CREATE TABLE inventory (
b_name    INTEGER NOT NULL REFERENCES weapons (weapon_id)
ON UPDATE CASCADE ON DELETE CASCADE,
sold_id     INTEGER NOT NULL REFERENCES soldier (id)
ON UPDATE CASCADE ON DELETE CASCADE,
PRIMARY KEY (b_name, sold_id)
);
