#=========================================================Remove Printer==========================================================#

$Destinationlog = (Get-ChildItem Env:\USERPROFILE).value + "\Log-info-printer\$($Printer).log"


Start-Transcript -Path $Destinationlog -Verbose -Append


$Printer = Read-Host "Entrez le nom de l'imprimante à supprimer"


Remove-Printer -Name $($Printer)


Stop-Transcript