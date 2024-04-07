$Service = Get-Service | select -Property * | Select-Object displayname,status | where {$_.displayname -match "f-secure"}
$Processus = Get-Process 

$Service