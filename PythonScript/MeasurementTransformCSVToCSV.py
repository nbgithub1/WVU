#Libraries for running this program , csv (built in library) for CSV read and write operations. 
#Pandas(need to install this if not already in machine, using - pip3 install pandas) for to convert time value to UTC.
import csv
import pandas as pd
"""
Author  : Nethan Binu
Purpose : To pivot a csv file generated by openPDC for various Measurement Key(s) with a timestamp and value 
        Input file has rows of data for each Measurement Key with columns as Signal ID, Measurement Key, Timestamp, Value 
        Output file has rows of data for each Timestamp with Columns as Timestamp, Measurement Key(s) (each as a separate column) 
"""
#-----Variables declared-----
#input File Name --change this value for processing a new file
inputFileName ='TimeMeasurementPPA5_8.csv' 
#output File Name --change this value to give a new name for outputfile
outputFileName ='TimeMeasurementPPA5_8_NewFormat.csv' 
#list variable to read all the Measurement Key(s) in the input file
allKeys = []
#uniqueKeys list will store the unique values of Measurement Key , e.g. PPA:5 , PPA:8
uniqueKeys = [] 
#initializing a Dictionary object (with first row key as 'Timestamp') to store the data in the new format for the output file
timeDict = {'Timestamp':[]} 

#------Step 1: Read all the Measurement Key(s) in the input file 
# Open the input file to 'inputfile' for reading, then assign all rows into 'reader'
# loop through rows and append/add the values of the measurementkey column in position 'keyIndex' to 'allKeys' list.
# line is a list, line[0] is signal ID, line[1] is measurement key, line[2] is timestamp, line[3] is value
with open(inputFileName, 'r') as inputfile:
    reader = csv.reader(inputfile, delimiter=',')
    for i, line in enumerate(reader):
        if i > 0:
            key = line[1]
            allKeys.append(key)            

#------Step 2: Find unique keys for building columns for the output file
#unique 'measurement keys' from allKeys is added to list uniqueKeys 
uniqueKeys = list(set(allKeys))
 
#------Step 3: Adding first row data for the output file
#setting headers for first row with key = 'Timestamp'
timeDict['Timestamp'] = uniqueKeys
 
#------Step 4: Building a list object to use as template for each row created for a timestamp
#for each unique measurementkey, a value of '0' is added to the template 
rowInit = []
for i in range(len(uniqueKeys)):
    rowInit.append(0)

#------Step 5:Read all the rows in the input file and add data to the output file
# Open the input file to 'inputfile' for reading, then assign all rows into 'reader'
# loop through rows and append/add the values to 'timeDict' 
with open(inputFileName, 'r') as inputfile:
    reader = csv.reader(inputfile, delimiter=',')
    for i, line in enumerate(reader):
        #first row is headers, so skipping
        if i > 0: 
            # ------Step 5(a): reading each row 
            # line is a list, line[0] is signal ID, line[1] is measurement key, line[2] is timestamp, line[3] is value
            time = line[2] 
            measurementKey = line[1]
            readingValue = line[3]

            # ------Step 5(b):making a copy of the row template for output dictionary
            rowData = rowInit.copy()  
            
            # ------Step 5(c):finding row from output 'timeDict' by timestamp as key 
            if time in timeDict.keys():
                rowData =timeDict[time]   
                
            # ------Step 5(d):finding the index of machineKey from uniqueKeys and updating the value in output row    
            index = uniqueKeys.index(measurementKey)
            rowData[index] = readingValue
        
            # ------Step 5(e): adding or updating the output row to output dictinary
            timeDict[time] = rowData 
      
#------Step 6:Writing to CSV file by the name given in 'outputFileName'
#open a file to write
#loop for each row in output dictionary 'timeDict'
outputFile = open(outputFileName, "w")
for k, v in timeDict.items():
    #k is timestamp, v is measurement key(s) list of values

    #------Step 6(a): Column 1 for timestamp
    #first row is header, dictionary key is Timestamp
    if k == 'Timestamp':        
        lineToWrite = str(k) + ','  
    else:
        # if not a heading row, take the timestamp and convert to UTC
        lineToWrite = str(pd.to_datetime(int(k))) + ','     
 
    #------Step 6(b): Columns for each unique measurement key  
    #build a loop for uniquekeys count 
    machineKeyCount = len(uniqueKeys)
    for i in range(len(uniqueKeys)):  
        #append column data (which is measurement key value) to 'lineToWrite'   
        lineToWrite = lineToWrite + str(v[i]) 
        #add a comma after each measurement key value (except for the last column)
        if machineKeyCount > 1:
            lineToWrite = lineToWrite + ','
            machineKeyCount = machineKeyCount - 1

    #------Step 6(c): #Writes "Timestamp, PPA7, PPA2" and creates a new line. 
    lineToWrite = lineToWrite + '\n' 

    #------Step 6(d): writes to file
    outputFile.write(lineToWrite)

#------Step 7: output file closed
outputFile.close()
 
