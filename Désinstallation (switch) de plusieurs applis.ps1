 Param(
  [Parameter(Mandatory=$True, helpmessage = " Entrez le nom d'ordinateur voulu ")]
   [string]  $Ordinateur = "$Env:ComputerName"
	
)


Write-Host "1 = 7-zip 16.02" -ForegroundColor Green -BackgroundColor Black
Write-Host "2 = Ccleaner" -ForegroundColor Green -BackgroundColor Black
Write-Host "3 = Putty" -ForegroundColor Green -BackgroundColor Black
Write-Host "4 = VLC" -ForegroundColor Green -BackgroundColor Black


#$Ordinateur = Read-Host "Entrez le nom d'un PC"
$Uninstall = Read-Host "Quelle application voulez-vous désinstallez ?"  


Start-Transcript -Verbose



Switch ($Uninstall) 
{

### 7-zip ###

("1") {Write-Host "AVERTISSEMENT : Désinstallation de 7-Zip" -ForegroundColor Red -BackgroundColor Black

start "C:\Program Files\7-Zip\Uninstall.exe"}

### Ccleaner ###

("2") {Write-Host "AVERTISSEMENT : Désinstallation de Ccleaner" -ForegroundColor Red -BackgroundColor Black 

start "C:\Program Files\Ccleaner\uninst.exe"}

### Putty ###

("3") {Write-Host "AVERTISSEMENT : Désinstallation de Putty " -ForegroundColor Red -BackgroundColor Black 

MsiExec.exe /X"{ED9EF59B-0799-428E-823D-6D2B7B4FE2E0}"}

### VLC ###

("4") {Write-Host "AVERTISSEMENT : Désinstallation de VLC " -ForegroundColor Red -BackgroundColor Black 

start "C:\Program Files (x86)\VideoLAN\VLC\uninstall.exe"}

###  ###

("5") {Write-Host "AVERTISSEMENT : Désinstallation de  " -ForegroundColor Red -BackgroundColor Black

start ""}





default {break + (Write-Host "Arret du script" -ForegroundColor Magenta -BackgroundColor Black )}



}

Stop-Transcript