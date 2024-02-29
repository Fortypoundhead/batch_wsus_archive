@echo off

REM ***
REM *** clear target directory
REM ***

del e:\source\wsus\*.* /Q

REM ***
REM *** Set some defaults
REM ***

REM Volume size

Set MyVolumeSize=1500m

REM Where the final resting place of the archive will be

Set Repository=E:\Source\wsus\

REM Path on target to be archived

Set PathToArchive=E:\WSUS\WsusContent

REM ***
REM *** Get the datestamp for the file, based on the current date
REM *** in the format YYYYMMDD
REM ***

echo. | date | FIND "(mm" > NUL
If errorlevel 1,(call :Parsedate DD MM) Else,(call :Parsedate MM DD)
goto :ScriptDone

:Parsedate

REM ***
REM *** The date is available. Parse the output of DATE /T
REM ***

For /F "tokens=1-4 delims=/.- " %%A in ('date /T') do if %%D!==! (set %1=%%A&set %2=%%B&set YYYY=%%C) else (set DOW=%%A&set %1=%%B&set %2=%%C&set YYYY=%%D)
(Set DateStamp=%YYYY%%MM%%DD%)

REM Build the filename

Set MyArchiveName=%YYYY%%MM%%DD%WSUS.7z

REM Inform the user of the stats

Echo.
Echo Archiving %PathToArchive%
Echo Target directory = %Repository%
Echo Base filename = %MyArchiveName%
Echo Volume Size = %MyVolumeSize%
Echo.
Echo beginning archive - this will take a bit.
Echo.

REM Compress the files in prep to send

7z a -r %Repository%%MyArchiveName% %PathToArchive% -v%MyVolumeSize%

REM Export catalog from WSUS

wsusutil export %Repository%%YYYY%%MM%%DD%_WSUSCatalog.xml.gz e:\scripts\%YYYY%%MM%%DD%_WSUSExport.log

ScriptDone:
