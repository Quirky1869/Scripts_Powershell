#==========================================================Add Printer=============================================================# 

$PC = Read-Host "Entrez nom PC"

$printer = "Server Name"

$printer += Read-Host "Enter a printer's name to add".ToUpper().Replace('a','A')

Write-Host $printer

Add-Printer -ComputerName $PC -ConnectionName $printer
Get-Printer | Out-GridView
