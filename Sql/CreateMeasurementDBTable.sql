#this script will create measurements database and the MeasurementTimeStamp table to store the measurement data from openPDC Custom output manager.
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