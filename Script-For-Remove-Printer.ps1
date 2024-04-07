#=========================================================Remove Printer==========================================================#

$Destinationlog = (Get-ChildItem Env:\USERPROFILE).value + "\Log-info-printer\$($Printer).log"


Start-Transcript -Path $Destinationlog -Verbose -Append


$Printer = Read-Host "Entrez le nom de l'imprimante à supprimer"
$Pc = Read-Host "Entrez le nom de l'ordinateur"

Remove-Printer -ComputerName $Pc -Name $($Printer)


Stop-Transcript