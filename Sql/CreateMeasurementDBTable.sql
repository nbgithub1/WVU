
DROP DATABASE IF EXISTS measurements;
CREATE DATABASE measurements;
USE measurements;
DROP TABLE IF EXISTS MeasurementTimeStamp;
CREATE TABLE MeasurementTimeStamp
(
SignalID VARCHAR(50) NOT NULL,
Timestamp VARCHAR(50) NOT NULL,
Value DOUBLE NOT NULL
);