$services = Get-Service | where {$_.displayname -match 'f-secure'}

foreach ($service in $services) {

    if ($service.status -eq "running"){

    Write-Host "Le service $($service.name) est actuellement : en marche" -ForegroundColor Green


    }
        elseif ($service.status -eq "stopped") {

        Write-Host "Le service $($service.name) est actuellement : arrété" -ForegroundColor Red

        }

}