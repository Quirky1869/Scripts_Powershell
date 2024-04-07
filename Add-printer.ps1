#==========================================================Add Printer=============================================================#
Write-Host  "Sous ce même format -> SHARP MX-M264N PCL6 - DSI" -ForegroundColor Green 

$PC = Read-Host "Entrez nom PC"

$printer = "\\printserv2\"

$printer += Read-Host "Entrez le nom de l'imprimante a ajouter".ToUpper().Replace('a','A')

Write-Host $printer

Add-Printer -ComputerName $PC -ConnectionName $printer

Get-Printer | Out-GridView