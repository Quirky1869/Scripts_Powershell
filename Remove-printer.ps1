#=========================================================Remove Printer==========================================================#

$destinationLog = (Get-ChildItem Env:\USERPROFILE).value + "\Log-info-printer\$($printer).log"

Start-Transcript -Path $destinationLog -Verbose -Append

$pc = Read-Host "Enter computer name"

$printer = "  ####Enter server name HERE ####   ".ToUpper()

$printer += Read-Host "Enter the printer name to delete".ToUpper()

Write-Host $printer

Remove-Printer -Name $printer -ComputerName $pc


Stop-Transcript