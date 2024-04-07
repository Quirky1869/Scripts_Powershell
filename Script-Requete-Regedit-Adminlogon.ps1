sl registry::hklm
sl software
sl microsoft
sl "Windows NT"
sl currentversion

Start-Sleep -Seconds 1

Get-Item -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"