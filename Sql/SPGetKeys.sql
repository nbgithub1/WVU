/*
Author: Nethan Binu
This script will create a stored procedure GetKeys , which will return the distinct values for the KeyColumn 
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
DROP PROCEDURE IF EXISTS GetKeys;


delimiter // 
CREATE PROCEDURE GetKeys(
	IN MeasurementTable VARCHAR(300)
	,IN MeasurementDetailTable VARCHAR(300)
	, IN KeyColumn VARCHAR(300)
	, IN IDColumn VARCHAR(300)
	,IN MeasurementDBName varchar(200)
	,IN OpenPDCDBName varchar(200)
)
BEGIN

#build dynamic sql to varaible selectKeys
SET @selectKeys  = concat( 'select ' ,  KeyColumn, ' from ',MeasurementDBName,'.',MeasurementTable  ,' mt join ',OpenPDCDBName,'.',MeasurementDetailTable
			, ' md on  mt.' ,IDColumn, ' = md.',IDColumn, ' group by ',KeyColumn  );
            #Prepare the dynamic sql to selectstmt
			PREPARE selectstmt FROM @selectKeys;
            #Execute the dynamic sql selectstmt
			EXECUTE selectstmt;
            DEALLOCATE PREPARE selectstmt;
END
//
delimiter ;
#test the stored procedure using the following command
#CALL GetKeys('measurementtimestamp','measurementdetail','Description','SignalID','measurements','openpdc');
#the above sample execution is equivalent to- 
#select Description from measurements.MeasurementTimeStamp mt join openpdc.measurementdetail md on mt.SignalID = md.SignalID group by Description    
    