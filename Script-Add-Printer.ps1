#==========================================================Add Printer=============================================================# 

$pc = Read-Host "Entrez nom PC"

Write-Host  "Sous ce même format -> SHARP MX-M264N PCL6 - DSI" -ForegroundColor Green

$printer = "\\printserv2\"

$printer += Read-Host "Entrez le nom de l'imprimante a ajouter".ToUpper().Replace('a','A')

Write-Host $printer

Add-Printer -ComputerName $pc -ConnectionName $printer

Get-Printer | Out-GridView