$ip = Read-Host "Adresse IP de l'imprimante"
$nom = Read-Host "Nom de l'imprimante"
$driver = Read-Host "Nom exact du driver"
#$location = Read-Host "L'emplacement de l'imprimante"

$location = $nom -replace('Copieur - ',"")
$portName = "$($ip)"

$checkPortExists = Get-Printerport -Name $portname -ErrorAction SilentlyContinue

if (-not $checkPortExists)
{

Add-PrinterPort -ComputerName 'PrintServ2' -name $portName #-PrinterHostAddress "192.168.8.223"}

}

Add-Printer -ComputerName 'PrintServ2' -Name "$($nom)" -DriverName "$($driver)" -PortName "$($ip)" -ShareName "$($nom)" -Location "$($location)" -Comment "IP : $($ip)" -Published -Shared

#SHARP MX-M266N PCL6
#SHARP MX-M264N PCL6
#Konica minolta 658eseriesPCL