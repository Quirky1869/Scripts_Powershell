############# A tester ##############

$computer = Read-Host "Entrer le nom de l'ordinateur distant voulu"
$service = Read-Host "Entrer le nom du service"

$choix = Read-Host "Voulez vous Arreter le service (Stop) ou le démmarer (Start)"

Switch ($choix)
{
# Stop service
   ("Stop") {Write-Host "Stop service" -ForegroundColor Red -BackgroundColor Black

    $Svc = Get-WmiObject -Computer $computer win32_service  -Filter "name='$($service)'"
    $Result = $Svc.StopService()
    $Result.ReturnValue
   }

#Start service
   ("Start") {Write-Host "Start service" -ForegroundColor Green -BackgroundColor Black

    $Svc = Get-WmiObject $computer win32_service  -Filter "name='$($service)'"
    $Result = $Svc.StartService()
    $Result.ReturnValue
   }


   default {break}

}

