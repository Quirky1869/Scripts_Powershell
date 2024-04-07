### Autoriser/Interdire périphériques de stockage ###

# Destination du fichier .log
$destinationLog = (Get-ChildItem Env:\USERPROFILE).value + "\enable-disable-device.log"

Start-Transcript -Path $destinationLog -Append

Write-Host "1 = Autoriser" -ForegroundColor Green -BackgroundColor Black
Write-Host "2 = Interdire" -ForegroundColor Red -BackgroundColor Black


#Choix#
$choix = Read-Host "Voulez vous Interdire ou Autoriser les périphériques de stockage ?"

Switch ($choix)
{
	
	("1")
	{
		# Autoriser
		reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 3 /f
	}
	
	
	("2")
	{
		# Interdire
		reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 4 /f
	}
	

        default { break + (Write-Host "Arret du script" -ForegroundColor Magenta -BackgroundColor Black) }
	
}

Stop-Transcript