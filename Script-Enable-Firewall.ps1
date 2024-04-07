# By : Micka
REG add "HKLM\SYSTEM\CurrentControlSet\services\MpsSvc" /v Start /t REG_DWORD /d 3 /f
Start-Service -Name mpssvc