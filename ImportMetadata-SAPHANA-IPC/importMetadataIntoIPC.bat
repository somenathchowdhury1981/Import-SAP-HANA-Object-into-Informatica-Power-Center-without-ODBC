::************************************************************************************
::Script Name : importMetadataIntoIPC.bat                                            *
::Author      : Somenath Chowdhury                                                   *
::Created On  : 22-December-2018                                                     *
::Description : This script is used export metadata of a SAP HANA (v2.0 SP3)         *
::              table or view in a XML format which is Informatica Power Center      *
::              (v10.2) compatible. The exported XML can easily be imported          *
::              into Informatica Power Center using pmrep command.                   *
::************************************************************************************
@echo Off
SetLocal EnableExtensions EnableDelayedExpansion
::====================================================================================
:: Declare constant variable value
::====================================================================================
set vSAPHANAhost=123.123.123.123
set vSAPHANAport=99999
set vSAPHANAInst=99
set vIPCRepo=dev_repository
set vIPCDomain=devp_domain
set vIPCSecurityDomain=XXXXX_XX
set vUserName=XXX999XXX
set vPassword=xxxxxxxxx
set vIPCUserName=XXX999XXX
set vIPCPassword=xxxxxxxx
::====================================================================================
:: User Input
::====================================================================================
set vPrompt=Enter Output File Path and Name
set vPrompt=%vPrompt% (Example: C:\Users\INFA.xml):
set /p filepathname=%vPrompt%

set vPrompt=Enter Informatica Power Center Folder Name
set vPrompt=%vPrompt% (Example: XXXXX_99_XXXXX_99):
set /p folderNameIPC=%vPrompt%

set /p exportSchemaName=Enter Schema Name:
set vPrompt=Enter Table Or View Name:
set /p exportTableViewName=%vPrompt%

set /p typeOfExport=Enter Type of XML (Example: SOURCE or TARGET):
::====================================================================================
:: Prepare SQL statement for XML generator procedure in SAP HANA
::====================================================================================
set vCallingProcedure=CALL TABLE_XML_GENERATOR('
set vCallingProcedure=%vCallingProcedure%%folderNameIPC%',UPPER('
set vCallingProcedure=%vCallingProcedure%%typeOfExport%'),UPPER('
set vCallingProcedure=%vCallingProcedure%%exportSchemaName%'),
set vCallingProcedure=%vCallingProcedure%'%exportTableViewName%');
::echo %vCallingProcedure%
::====================================================================================
::
::====================================================================================
:: Prepare SELECT statement to extract XML content from Table
::====================================================================================
set vSelectStmt=SELECT TO_CHAR(XML_STRING) FROM XML_EXPORT_FOR_IPC WHERE
set vSelectStmt=%vSelectStmt% XML_GENERATION_USER = UPPER('%username%');
::echo %vSelectStmt%
::====================================================================================
::
::====================================================================================
:: Prepare and Execute Procedure for XML generation
::====================================================================================
set vhdbsqlstmt1="C:\Program Files\sap\hdbclient\"hdbsql.exe -n
set vhdbsqlstmt1=%vhdbsqlstmt1% %vSAPHANAhost%:%vSAPHANAport% -i %vSAPHANAInst%
set vhdbsqlstmt1=%vhdbsqlstmt1% -u %vUserName% -p %vPassword% -x %vCallingProcedure%
::echo %vhdbsqlstmt1%
%vhdbsqlstmt1%
::====================================================================================
::
::====================================================================================
:: Prepare and Execute Procedure for exporting XML into file
::====================================================================================
set vhdbsqlstmt2="C:\Program Files\sap\hdbclient\"hdbsql.exe -n
set vhdbsqlstmt2=%vhdbsqlstmt2% %vSAPHANAhost%:%vSAPHANAport% -i %vSAPHANAInst%
set vhdbsqlstmt2=%vhdbsqlstmt2% -u %vUserName% -p %vPassword% -x -resultencoding UTF8
set vhdbsqlstmt2=%vhdbsqlstmt2% -a -C -o "%filepathname%" %vSelectStmt%
::echo %vhdbsqlstmt2%
%vhdbsqlstmt2%
::====================================================================================
::
::====================================================================================
:: Prepare pmrep command to connect Informatica Power Center
::====================================================================================
set vpmrepIPCConnect="C:\Program Files\Informatica\10.2.0\clients\
set vpmrepIPCConnect=%vpmrepIPCConnect%PowerCenterClient\client\bin\pmrep.exe"
set vpmrepIPCConnect=%vpmrepIPCConnect% connect -r %vIPCRepo% -d %vIPCDomain%
set vpmrepIPCConnect=%vpmrepIPCConnect% -n %vIPCUserName% -s %vIPCSecurityDomain%
set vpmrepIPCConnect=%vpmrepIPCConnect% -x %vIPCPassword%
::echo %vpmrepIPCConnect%
%vpmrepIPCConnect%
::====================================================================================
::
::====================================================================================
:: Prepare pmrep command to import XML into Informatica Power Center
::====================================================================================
set vpmrepIPCImport="C:\Program Files\Informatica\10.2.0\clients\
set vpmrepIPCImport=%vpmrepIPCImport%PowerCenterClient\client\bin\pmrep.exe"
set vpmrepIPCImport=%vpmrepIPCImport% ObjectImport -i "%filepathname%"
set vpmrepIPCImport=%vpmrepIPCImport% -c "C:\Program Files\Informatica\10.2.0\
set vpmrepIPCImport=%vpmrepIPCImport%clients\PowerCenterClient\client\bin\
set vpmrepIPCImport=%vpmrepIPCImport%import_control_file.txt"
::echo %vpmrepIPCImport%
%vpmrepIPCImport%

pause
goto :Eof