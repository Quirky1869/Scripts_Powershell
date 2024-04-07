$services = Get-Service | where {$_.displayname -match 'f-secure'}

foreach ($Service in $services) {

    if ($Service.status -eq "running"){

    Write-Host "Le service $($Service.name) est actuellement : en marche" -ForegroundColor Green


    }
        elseif ($Service.status -eq "stopped") {

        Write-Host "Le service $($Service.name) est actuellement : arrété" -ForegroundColor Red

        }

}