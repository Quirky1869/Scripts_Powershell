@echo off

Xcopy "\\sccm2012\sccm_repository$\Software\Scripts\CheckMappingNetworkDrive\mappage lecteurs.cmd" "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" /Y