#==========================================================Add Printer=============================================================# 

$PC = Read-Host "Entrez nom PC"

$printer = "Server Name"

$printer += Read-Host "Entrez le nom de l'imprimante a ajouter".ToUpper().Replace('a','A')

Write-Host $printer

Add-Printer -ComputerName $PC -ConnectionName $printer

Get-Printer | Out-GridView