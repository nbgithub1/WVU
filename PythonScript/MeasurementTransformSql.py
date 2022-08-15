import csv
import pandas as pd
import MySQLdb
import os

uniqueKeys = []
#Dictionary object to write the data in the new format 
timeDict = {'Timestamp':[]} 
measurementTableName= 'measurementtimestamp'
measurementDetailTableName= 'measurementdetail'
keyColumnName = 'Description'
idColumnName = 'SignalID'
measurementDBName =  'measurements'
openPDCDBName =  'openpdc'
outFileName = 'NewFormatFromDB'+ measurementTableName +'.csv'
hostIPAddress = 'XXX.XXX.X.XX'
mySQLUserName = 'nethan'
db_password = os.environ.get('DB_PASS')
#connection 
def connection():
    conn = MySQLdb.connect(
        host=hostIPAddress,
        user=mySQLUserName, 
        password=db_password,
        db=measurementDBName,
    )
    return conn


# Open the source file to variable f for reading, then all rows into var reader
# loop through rows and append/add the values of the measurementkey column 
# to allKeys array. 
# unique values from allKeys is added to uniqueKeys array
 

conn = connection()
cur = conn.cursor()
#queryKeys = "select Description from MeasurementTimeStampPPA8_9_10 mt join measurementdetail md on mt.SignalID = md.SignalID group by Description"
#cur.execute(queryKeys)
cur.callproc('GetKeys',[measurementTableName,measurementDetailTableName,keyColumnName,idColumnName,measurementDBName,openPDCDBName])


#finding unique keys
for row in cur:
    for field in row:
        uniqueKeys.append(field) 
#print(uniqueKeys)  
cur.close()

cur = conn.cursor()
#queryMeasurement = "select mt.SignalID,Description,Timestamp,Value from MeasurementTimeStampPPA8_9_10 mt join measurementdetail md on mt.SignalID = md.SignalID order by  Timestamp"
#cur.execute(queryMeasurement)
cur.callproc('GetMeasurementDetails',[measurementTableName,measurementDetailTableName,keyColumnName,idColumnName,measurementDBName,openPDCDBName])

#setting headers for key = 'Timestamp'
timeDict['Timestamp'] = uniqueKeys

#print(timeDict)

#
rowInit = []
for i in range(len(uniqueKeys)):
    rowInit.append(0)

i = 0
for line in cur.fetchall():
    #print(line)
    
    time = line[2] 
    measurementKey = line[1]
    readingValue = line[3]

    rowData = rowInit.copy() 
    #print('rowData initialized for '+ measurementKey )
    #print(rowData)
    
    
    if time in timeDict.keys():
        rowData =timeDict[time]   
        #print('rowData found in dictionary for time ' + time)
        #print(rowData)
        
    # find the index of machineKey from csv and set the value n
    index = uniqueKeys.index(measurementKey)
    rowData[index] = readingValue

    #print('rowData updated for ' + measurementKey )
    #print(rowData)
    timeDict[time] = rowData
    #print(time)
    #print(timeDict)
    #print('-----') 
     
cur.close()


f = open(outFileName, "w")
for k, v in timeDict.items():     
    strToWrite = str(k) + ',' #First will write the Timestamp    

    machineKeyCount = len(uniqueKeys)

    for i in range(len(uniqueKeys)):      
        strToWrite = strToWrite + str(v[i]) #Then adds Desc1 first loop and then Desc2 in second loop, so on.  
                                                                                                                                
        if machineKeyCount > 1:
            strToWrite = strToWrite + ','
            machineKeyCount = machineKeyCount - 1

    strToWrite = strToWrite + '\n' #Writes "Timestamp, Desc1, Desc2 etc." and creates a new line. After the heading it will write ("UTC Value, Desc1 Value, Desc2 Value etc.")

    f.write(strToWrite)
f.close()
