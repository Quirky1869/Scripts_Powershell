﻿#1..254 | ForEach-Object {Test-Connection -ComputerName "192.168.100.$_" -Count 1 -ErrorAction SilentlyContinue}

$Destination = (Get-ChildItem Env:\USERPROFILE).value + "\Rangeip.csv"

Write-Host "Taper les trois premier octet à checker : " -NoNewline -ForegroundColor Cyan -BackgroundColor Black

$ipAddress = Read-Host

Write-Host "Execution du script en cours veuillez patientez ..." -ForegroundColor Cyan -BackgroundColor Black

$rangeIp = 1..254 | ForEach-Object {Get-WmiObject -Class Win32_PingStatus -Filter "Address='$($ipAddress).$_' and Timeout=200 and ResolveAddressNames='true' and StatusCode=0" | select ProtocolAddress*} -Verbose

$rangeIp | Out-File -FilePath $Destination -Append

Write-Host "Génération du fichier excel en cours" -ForegroundColor Green -BackgroundColor Black

Invoke-Item -Path $Destination