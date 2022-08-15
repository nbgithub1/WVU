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

#MeasurementTable -- output table from openpdc
#MeasurementDetailTable -- the detail to get the measurement related details
#KeyColumn - the columns in the output CSV to organize the data based on 
#IDColumn -- Primary Key column to combine the data using join

#build dynamic sql and execute
SET @selectKeys  = concat( 'select ' ,  KeyColumn, ' from ',MeasurementDBName,'.',MeasurementTable  ,' mt join ',OpenPDCDBName,'.',MeasurementDetailTable
			, ' md on  mt.' ,IDColumn, ' = md.',IDColumn, ' group by ',KeyColumn  );
			PREPARE selectstmt FROM @selectKeys;
			EXECUTE selectstmt;
            DEALLOCATE PREPARE selectstmt;
#select Description from MeasurementTimeStampPPA8_9_10 mt join measurementdetail md on mt.SignalID = md.SignalID group by Description            

END
//
delimiter ;

#CALL GetKeys('measurementtimestamp','measurementdetail','Description','SignalID','measurements','openpdc');
    