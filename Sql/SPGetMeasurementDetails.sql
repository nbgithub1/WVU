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

#MeasurementTable -- output table from openpdc
#MeasurementDetailTable -- the detail to get the measurement related details
#KeyColumn - the columns in the output CSV to organize the data based on 
#IDColumn -- Primary Key column to combine the data using join

SET @selectData  = concat( 'select mt.' ,IDColumn,',' , KeyColumn , ',Timestamp,Value from ',MeasurementDBName,'.'
, MeasurementTable, '  mt join ',OpenPDCDBName,'.',MeasurementDetailTable, ' md on  mt.' ,IDColumn, ' = md.',IDColumn, ' order by Timestamp'  );
			PREPARE selectstmtdetail FROM @selectData;
			EXECUTE selectstmtdetail;
            DEALLOCATE PREPARE selectstmtdetail;
 #select mt.SignalID,Description,Timestamp,Value from MeasurementTimeStampPPA8_9_10 mt join measurementdetail md on mt.SignalID = md.SignalID order by  Timestamp           

END
//-
delimiter ;

#CALL GetMeasurementDetails('measurementtimestamp','measurementdetail','Description','SignalID','measurements','openpdc');