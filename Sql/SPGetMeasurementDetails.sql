/*
Author: Nethan Binu
This script will create a stored procedure GetMeasurementDetails , which will return the measurement details 
by joining the measurements table with the measurementdetail table from openpdc database. 
This uses dynamic sql to make it more generic based on the parameter values.
Parameters:
MeasurementTable -- output table from openpdc manager with measurement data , e.g. 'measurementtimestamp'
MeasurementDetailTable -- name of the view to get the measurement related details , e.g. 'measurementdetail'
KeyColumn - The Pythoon program will use the unique values of this column to create the columns in the output csv file, e.g. 'Description'
IDColumn -- Primary Key column to combine the data using join with MeasurementDetail view, e.g. 'SignalID'
measurementDBName	name of measurement database, e.g 'measurements'
openPDCDBName - name of openPDC configuration database, e.g. 'openpdc'
*/

USE measurements;
DROP PROCEDURE IF EXISTS GetMeasurementDetails;

delimiter // 
CREATE PROCEDURE GetMeasurementDetails(
	IN MeasurementTable VARCHAR(300)
	,IN MeasurementDetailTable VARCHAR(300)
	,IN KeyColumn VARCHAR(300)
	,IN IDColumn VARCHAR(300)
	,IN MeasurementDBName varchar(200)
	,IN OpenPDCDBName varchar(200)
)
BEGIN
#build dynamic sql to varaible selectKeys
SET @selectData  = concat( 'select mt.' ,IDColumn,',' , KeyColumn , ',Timestamp,Value from ',MeasurementDBName,'.'
, MeasurementTable, '  mt join ',OpenPDCDBName,'.',MeasurementDetailTable, ' md on  mt.' ,IDColumn, ' = md.',IDColumn, ' order by Timestamp'  );
			#Prepare the dynamic sql to selectstmt
			PREPARE selectstmtdetail FROM @selectData;
            #Execute the dynamic sql selectstmt
			EXECUTE selectstmtdetail;
            DEALLOCATE PREPARE selectstmtdetail;
 END
//-
delimiter ;
#test the stored procedure using the following command
#CALL GetMeasurementDetails('measurementtimestamp','measurementdetail','Description','SignalID','measurements','openpdc');
#the above sample execution is equivalent to- 
#select mt.SignalID,Description,Timestamp,Value from measurements.MeasurementTimeStamp mt join openpdc.measurementdetail md on mt.SignalID = md.SignalID order by  Timestamp      