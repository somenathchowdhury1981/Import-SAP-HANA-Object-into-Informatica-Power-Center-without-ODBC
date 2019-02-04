# Import SAP HANA Object into Informatica Power Center without ODBC

Import SAP HANA Object into Informatica Power Center without ODBC

## Project Developer
Somenath Chowdhury (somenath.chowdhury@ymail.com)

## What does this utility do?
This tool imports metadata of SAP HANA objects (Tables or View) into Informatica Power Center v10.2 without ODBC driver at client machine.

## When do we use it?
This tool could be used mainly when

1. SAP HANA ODBC driver is not available in client machine
2. Computing mismatch of the ODBC driver in the client machine like 32 bit Informatica Power Center Designer and 64 bit SAP HANA ODBC Driver.

### Prerequisites
SAP HANA Client and Informatica Power Center (v10.x) are required as a prerequisites to set up this tool

### Installation
Process steps of this tool are available in (ImportSAPHANAObject_Into_IPC_without_ODBC.pdf) document.

## Running the tests

Execution Steps are as follows:

The “importMetadataIntoIPC.bat” file is used as a user interface to import metadata of a SAP HANA
table or view into Informatica Power Center (v10.2).

This batch file will take user input such as –
1. Informatica Power Center folder name in which the metadata of the SAP HANA object is imported
2. Schema name of the SAP HANA object
3. SAP HANA object name for table or view
4. Type of import SOURCE or TARGET

Based on user input, the batch process is connected to SAP HANA instance and triggered 
TABLE_XML_GENERATOR procedure using hdbsql. Using hdbsql, the output of the procedure is extracted and stored as a XML file in the client location.

After generation of the XML file, Informatica Power Center repository is connected and import the
extracted XML file using pmrep command.​
