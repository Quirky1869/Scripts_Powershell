@ECHO OFF
CLS
setLocal EnableDelayedExpansion
REM The textfile to store the printers
SET textFile=C:\printers.txt
REM Clear the text file and start new
COPY /Y NUL !textFile! >nul 2>&1


WMIC PRINTER GET Caption,PortName > C:\Printers.txt
   

\\%COMPUTERNAME%\C$\printers.txt