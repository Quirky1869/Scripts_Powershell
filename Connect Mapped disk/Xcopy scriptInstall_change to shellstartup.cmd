@echo off

Xcopy "\\sccm2012\sccm_repository$\Software\Scripts\CheckMappingNetworkDrive\scriptInstall_change.ps1" "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" /Y