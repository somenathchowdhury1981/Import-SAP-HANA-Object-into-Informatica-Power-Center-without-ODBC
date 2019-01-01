::*******************************************************************************
::Script Name : importMetadataIntoIPC.bat                                       *
::Author      : Somenath Chowdhury                                              *
::Created On  : 22-December-2018                                                *
::Description : This script is used export metadata of a SAP HANA (v2.0 SP3)    *
::              table or view in a XML format which is Informatica Power Center *
::              (v10.2) compatible. The exported XML can easily be imported     *
::              into Informatica Power Center using pmrep command.              *
::*******************************************************************************
@echo Off
SetLocal EnableExtensions EnableDelayedExpansion
::===============================================================================
:: Declare constant variable value
::===============================================================================
set vSAPHANAhost=123.123.123.123
set vSAPHANAport=99999
set vSAPHANAInst=99
set vIPCRepo=dev_repository
set vIPCDomain=devp_domain
set vIPCSecurityDomain=XXXXX_XX
::===============================================================================
:: User Input
::===============================================================================
set /p username=Enter User Name (SAP HANA):
set /P "=Enter a Password (SAP HANA):" < Nul
call :PasswordInput

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
::===============================================================================
:: Prepare SQL statement for XML generator procedure in SAP HANA
::===============================================================================
set vCallingProcedure=CALL TABLE_XML_GENERATOR('
set vCallingProcedure=%vCallingProcedure%%folderNameIPC%',UPPER('
set vCallingProcedure=%vCallingProcedure%%typeOfExport%'),UPPER('
set vCallingProcedure=%vCallingProcedure%%exportSchemaName%'),
set vCallingProcedure=%vCallingProcedure%'%exportTableViewName%');
::echo %vCallingProcedure%
::===============================================================================
::
::===============================================================================
:: Prepare SELECT statement to extract XML content from Table
::===============================================================================
set vSelectStmt=SELECT TO_CHAR(XML_STRING) FROM XML_EXPORT_FOR_IPC WHERE
set vSelectStmt=%vSelectStmt% XML_GENERATION_USER = UPPER('%username%');
::echo %vSelectStmt%
::===============================================================================
::
::===============================================================================
:: Prepare and Execute Procedure for XML generation
::===============================================================================
set vhdbsqlstmt1="C:\Program Files\sap\hdbclient\"hdbsql.exe -n
set vhdbsqlstmt1=%vhdbsqlstmt1% %vSAPHANAhost%:%vSAPHANAport% -i %vSAPHANAInst%
set vhdbsqlstmt1=%vhdbsqlstmt1% -u %username% -p !Line! -x %vCallingProcedure%
::echo %vhdbsqlstmt1%
%vhdbsqlstmt1%
::===============================================================================
::
::===============================================================================
:: Prepare and Execute Procedure for exporting XML into file
::===============================================================================
set vhdbsqlstmt2="C:\Program Files\sap\hdbclient\"hdbsql.exe -n
set vhdbsqlstmt2=%vhdbsqlstmt2% %vSAPHANAhost%:%vSAPHANAport% -i %vSAPHANAInst%
set vhdbsqlstmt2=%vhdbsqlstmt2% -u %username% -p !Line! -x -resultencoding UTF8
set vhdbsqlstmt2=%vhdbsqlstmt2% -a -C -o "%filepathname%" %vSelectStmt%
::echo %vhdbsqlstmt2%
%vhdbsqlstmt2%
::===============================================================================
::
echo XML file is generated successfully....
set /p ipcUserName=Enter User Name (Informatica Power Center 10.2):
set /P "=Enter a Password (Informatica Power Center 10.2):" < Nul
call :PasswordInputIPC
::
::===============================================================================
:: Prepare pmrep command to connect Informatica Power Center
::===============================================================================
set vpmrepIPCConnect="C:\Program Files\Informatica\10.2.0\clients\
set vpmrepIPCConnect=%vpmrepIPCConnect%PowerCenterClient\client\bin\pmrep.exe"
set vpmrepIPCConnect=%vpmrepIPCConnect% connect -r %vIPCRepo% -d %vIPCDomain%
set vpmrepIPCConnect=%vpmrepIPCConnect% -n %ipcUserName% -s %vIPCSecurityDomain%
set vpmrepIPCConnect=%vpmrepIPCConnect% -x !LineIPC!
::echo %vpmrepIPCConnect%
%vpmrepIPCConnect%
::===============================================================================
::
::===============================================================================
:: Prepare pmrep command to import XML into Informatica Power Center
::===============================================================================
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

:PasswordInput
::Author: Carlos Montiers Aguilera
::Last updated: 20150401. Created: 20150401.
::Set in variable Line a input password
For /F skip^=1^ delims^=^ eol^= %%# in (
'"Echo(|Replace.exe "%~f0" . /U /W"') Do Set "CR=%%#"
For /F %%# In (
'"Prompt $H &For %%_ In (_) Do Rem"') Do Set "BS=%%#"
Set "Line="
:_PasswordInput_Kbd
Set "CHR=" & For /F skip^=1^ delims^=^ eol^= %%# in (
'Replace.exe "%~f0" . /U /W') Do Set "CHR=%%#"
If !CHR!==!CR! Echo(&Goto :Eof
If !CHR!==!BS! (If Defined Line (Set /P "=!BS! !BS!" <Nul
Set "Line=!Line:~0,-1!"
)
) Else (Set /P "=*" <Nul
If !CHR!==! (Set "Line=!Line!^!"
) Else Set "Line=!Line!!CHR!"
)
Goto :_PasswordInput_Kbd

:PasswordInputIPC
::Author: Carlos Montiers Aguilera
::Last updated: 20150401. Created: 20150401.
::Set in variable Line a input password
For /F skip^=1^ delims^=^ eol^= %%# in (
'"Echo(|Replace.exe "%~f0" . /U /W"') Do Set "CR=%%#"
For /F %%# In (
'"Prompt $H &For %%_ In (_) Do Rem"') Do Set "BS=%%#"
Set "LineIPC="
:_PasswordInput_KbdIPC
Set "CHR=" & For /F skip^=1^ delims^=^ eol^= %%# in (
'Replace.exe "%~f0" . /U /W') Do Set "CHR=%%#"
If !CHR!==!CR! Echo(&Goto :Eof
If !CHR!==!BS! (If Defined LineIPC (Set /P "=!BS! !BS!" <Nul
Set "LineIPC=!LineIPC:~0,-1!"
)
) Else (Set /P "=*" <Nul
If !CHR!==! (Set "LineIPC=!LineIPC!^!"
) Else Set "LineIPC=!LineIPC!!CHR!"
)
Goto :_PasswordInput_KbdIPC