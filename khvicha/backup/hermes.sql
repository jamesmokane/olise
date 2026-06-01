/*
  Application: Hermes Portfolio Tracker
  Created: 2026-02-24
  Description: This script initializes the database 
  and inserts initial FX option trades.
*/

-- Clean up existing data
DROP TABLE IF EXISTS trades;
DROP TABLE IF EXISTS portfolios;
DROP TABLE IF EXISTS valuations;
DROP TABLE IF EXISTS trade_valuations;
DROP TABLE IF EXISTS non_business_days;

-- Create the Hermes trade table
CREATE TABLE trades 
(
	trade_ID INTEGER NOT NULL,
	leg INTEGER NOT NULL,
	portfolio_ID TEXT NOT NULL,	
	notional REAL NOT NULL,
	trade_type TEXT CHECK(length(trade_type) <= 10),
	premium REAL DEFAULT 0.0,
	trade_date TEXT CHECK (expiry_date LIKE '____-__-__'),
	expiry_date TEXT CHECK (expiry_date LIKE '____-__-__'),
	strike REAL,
	barrier1 REAL,
	barrier2 REAL,
	settlement_date TEXT CHECK (expiry_date LIKE '____-__-__'),
	delivery_date TEXT CHECK (expiry_date LIKE '____-__-__'),
	model TEXT DEFAULT 'std',
	PRIMARY KEY (trade_ID, leg)
);

-- Insert seed data
INSERT INTO trades (trade_ID, leg, portfolio_ID, notional, trade_type, premium, trade_date, expiry_date, strike, barrier1, barrier2, settlement_date, delivery_date)
VALUES (1, 1, 1, 100000, 'Call', 10000, '2026-01-01', '2026-07-01', 7000, NULL, NULL, '2026-01-03', '2026-07-03');

INSERT INTO trades (trade_ID, leg, portfolio_ID, notional, trade_type, premium, trade_date, expiry_date, strike, barrier1, barrier2, settlement_date, delivery_date)
VALUES (2, 1, 1, 10000000, 'Call', 80000, '2026-02-01', '2026-08-01', 7200, NULL, NULL, '2026-02-03', '2026-08-03');

INSERT INTO trades (trade_ID, leg, portfolio_ID, notional, trade_type, premium, trade_date, expiry_date, strike, barrier1, barrier2, settlement_date, delivery_date)
VALUES (3, 1, 1, 525000, 'Call', 10000, '2026-02-10', '2027-01-10', 7500, NULL, NULL, '2026-02-12', '2027-01-12');

INSERT INTO trades (trade_ID, leg, portfolio_ID, notional, trade_type, premium, trade_date, expiry_date, strike, barrier1, barrier2, settlement_date, delivery_date)
VALUES (4, 1, 1, 1800000, 'Call', 7400, '2026-02-14', '2026-11-14', 7550, NULL, NULL, '2026-02-16', '2026-11-16');

INSERT INTO trades (trade_ID, leg, portfolio_ID, notional, trade_type, premium, trade_date, expiry_date, strike, barrier1, barrier2, settlement_date, delivery_date)
VALUES (5, 1, 2, 10000, 'Call', 3260, '2026-02-21', '2026-08-21', 7600, NULL, NULL, '2026-02-23', '2026-08-23');

INSERT INTO trades (trade_ID, leg, portfolio_ID, notional, trade_type, premium, trade_date, expiry_date, strike, barrier1, barrier2, settlement_date, delivery_date)
VALUES (6, 1, 2, 260000, 'Call', 9720, '2026-02-01', '2027-08-01', 7700, NULL, NULL, '2026-02-03', '2027-08-03');


-- Create valuations IDs
CREATE TABLE portfolios
(
	ID INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	asset TEXT NOT NULL
);

-- Insert seed portfolios
INSERT INTO portfolios (name, asset)
VALUES ('Portfolio 1','S&P500');

INSERT INTO portfolios (name, asset)
VALUES ('Portfolio 2','S&P500-LOWRISK');

-- Create valuations IDs
CREATE TABLE valuations 
(
	ID INTEGER PRIMARY KEY AUTOINCREMENT,
	portfolio_ID INTEGER,
	valuation_time TEXT,
	-- Save market data used.
	S REAL,
	rate REAL,
	vol REAL,
	FOREIGN KEY (portfolio_ID) REFERENCES portfolios (ID)
);

-- Insert seed valuations
INSERT INTO valuations (portfolio_ID, valuation_time, S, rate, vol)
VALUES (1, '2026-01-01T12:00:00', 7068.25, 0.0364, 0.1812);

INSERT INTO valuations (portfolio_ID, valuation_time, S, rate, vol)
VALUES (2, '2026-01-01T12:15:03', 7068.25, 0.0364, 0.1812);

-- Create the trade valuations table
CREATE TABLE trade_valuations 
(
	valuation_ID INTEGER REFERENCES valuations(ID),
	trade_ID INTEGER NOT NULL,
	leg INTEGER NOT NULL,
	model TEXT NOT NULL,
	-- Greeks.
	PV REAL NOT NULL,
	delta REAL,
	gamma REAL,
	rho REAL,
	vega REAL,
	theta REAL,
	FOREIGN KEY (valuation_ID) REFERENCES valuations (ID),
	FOREIGN KEY (trade_ID, leg) REFERENCES trades (trade_ID, leg)
);

-- Insert seed trade valuation data.
INSERT INTO trade_valuations (valuation_ID, trade_ID, leg, model, PV, delta, gamma, rho, vega, theta)
VALUES (1, 1, 1, 'std', 1.23, 1.34, 1.45, 1.56, 1.67, 1.78);

INSERT INTO trade_valuations (valuation_ID, trade_ID, leg, model, PV, delta, gamma, rho, vega, theta)
VALUES (1, 2, 1, 'std', 2.23, 2.34, 2.45, 2.56, 2.67, 2.78);

INSERT INTO trade_valuations (valuation_ID, trade_ID, leg, model, PV, delta, gamma, rho, vega, theta)
VALUES (1, 3, 1, 'std', 3.23, 3.34, 3.45, 3.56, 3.67, 3.78);

INSERT INTO trade_valuations (valuation_ID, trade_ID, leg, model, PV, delta, gamma, rho, vega, theta)
VALUES (1, 4, 1, 'std', 4.23, 4.34, 4.45, 4.56, 4.67, 4.78);

-- Create non-business-days (holidays)
CREATE TABLE non_business_days
(
	location TEXT NOT NULL,
	reason TEXT,
	non_business_day TEXT NOT NULL
);

-- Next 3 years holidays for UK
INSERT INTO non_business_days VALUES ('UK', 'New Years Holiday',   '2026-01-02');
INSERT INTO non_business_days VALUES ('UK', 'Good Friday',         '2026-04-03');
INSERT INTO non_business_days VALUES ('UK', 'Easter',              '2026-04-06');
INSERT INTO non_business_days VALUES ('UK', 'May Bank Holiday',    '2026-05-04');
INSERT INTO non_business_days VALUES ('UK', 'Spring Bank Holiday', '2026-05-25');
INSERT INTO non_business_days VALUES ('UK', 'Summer Bank Holiday', '2026-08-31');
INSERT INTO non_business_days VALUES ('UK', 'Christmas Day',       '2026-12-25');
INSERT INTO non_business_days VALUES ('UK', 'Boxing Day',          '2026-12-28');

INSERT INTO non_business_days VALUES ('UK', 'New Years Holiday',   '2027-01-02');
INSERT INTO non_business_days VALUES ('UK', 'Good Friday',         '2027-03-26');
INSERT INTO non_business_days VALUES ('UK', 'Easter',              '2027-03-29');
INSERT INTO non_business_days VALUES ('UK', 'May Bank Holiday',    '2027-05-03');
INSERT INTO non_business_days VALUES ('UK', 'Spring Bank Holiday', '2027-05-31');
INSERT INTO non_business_days VALUES ('UK', 'Summer Bank Holiday', '2027-08-30');
INSERT INTO non_business_days VALUES ('UK', 'Christmas Day',       '2027-12-27');
INSERT INTO non_business_days VALUES ('UK', 'Boxing Day',          '2027-12-28');

INSERT INTO non_business_days VALUES ('UK', 'New Years Holiday',   '2028-01-03');
INSERT INTO non_business_days VALUES ('UK', 'Good Friday',         '2028-04-14');
INSERT INTO non_business_days VALUES ('UK', 'Easter',              '2028-04-17');
INSERT INTO non_business_days VALUES ('UK', 'May Bank Holiday',    '2028-05-01');
INSERT INTO non_business_days VALUES ('UK', 'Spring Bank Holiday', '2028-05-29');
INSERT INTO non_business_days VALUES ('UK', 'Summer Bank Holiday', '2028-08-28');
INSERT INTO non_business_days VALUES ('UK', 'Christmas Day',       '2028-12-25');
INSERT INTO non_business_days VALUES ('UK', 'Boxing Day',          '2028-12-26');

-- Next 3 years holidays for UK
INSERT INTO non_business_days VALUES ('US', 'New Years Day',                        '2026-01-01');
INSERT INTO non_business_days VALUES ('US', 'Martin Luther King Jr. Day',           '2026-01-19');
INSERT INTO non_business_days VALUES ('US', 'Presidents Day',                      '2026-02-16');
INSERT INTO non_business_days VALUES ('US', 'Memorial Day',                         '2026-05-25');
INSERT INTO non_business_days VALUES ('US', 'Juneteenth National Independence Day', '2026-06-19');
INSERT INTO non_business_days VALUES ('US', 'Independence Day',                     '2026-07-04');
INSERT INTO non_business_days VALUES ('US', 'Labor Day',                            '2026-09-07');
INSERT INTO non_business_days VALUES ('US', 'Columbus Day',                         '2026-10-12');
INSERT INTO non_business_days VALUES ('US', 'Veterans Day',                         '2026-11-11');
INSERT INTO non_business_days VALUES ('US', 'Thanksgiving Day',                     '2026-11-26');
INSERT INTO non_business_days VALUES ('US', 'Christmas Day',                        '2026-12-25');

INSERT INTO non_business_days VALUES ('US', 'New Years Day',                        '2027-01-01');
INSERT INTO non_business_days VALUES ('US', 'Martin Luther King Jr. Day',           '2027-01-18');
INSERT INTO non_business_days VALUES ('US', 'Presidents Day',                      '2027-02-15');
INSERT INTO non_business_days VALUES ('US', 'Memorial Day',                         '2027-05-31');
INSERT INTO non_business_days VALUES ('US', 'Juneteenth National Independence Day', '2027-06-18');
INSERT INTO non_business_days VALUES ('US', 'Independence Day',                     '2027-07-04');
INSERT INTO non_business_days VALUES ('US', 'Labor Day',                            '2027-09-06');
INSERT INTO non_business_days VALUES ('US', 'Columbus Day',                         '2027-10-11');
INSERT INTO non_business_days VALUES ('US', 'Veterans Day',                         '2027-11-11');
INSERT INTO non_business_days VALUES ('US', 'Thanksgiving Day',                     '2027-11-25');
INSERT INTO non_business_days VALUES ('US', 'Christmas Day',                        '2027-12-25');

INSERT INTO non_business_days VALUES ('US', 'New Years Day',                        '2028-01-01');
INSERT INTO non_business_days VALUES ('US', 'Martin Luther King Jr. Day',           '2028-01-17');
INSERT INTO non_business_days VALUES ('US', 'Presidents Day',                      '2028-02-21');
INSERT INTO non_business_days VALUES ('US', 'Memorial Day',                         '2028-05-29');
INSERT INTO non_business_days VALUES ('US', 'Juneteenth National Independence Day', '2028-06-19');
INSERT INTO non_business_days VALUES ('US', 'Independence Day',                     '2028-07-04');
INSERT INTO non_business_days VALUES ('US', 'Labor Day',                            '2028-09-04');
INSERT INTO non_business_days VALUES ('US', 'Columbus Day',                         '2028-10-09');
INSERT INTO non_business_days VALUES ('US', 'Veterans Day',                         '2028-11-10');
INSERT INTO non_business_days VALUES ('US', 'Thanksgiving Day',                     '2028-11-23');
INSERT INTO non_business_days VALUES ('US', 'Christmas Day',                        '2028-12-25');


