### Stop service TW 192.168.8.227 RDV ne s'enregistre pas ###

Stop-Process -ProcessName TWtrace -Force -ErrorAction SilentlyContinue

Start-Sleep -Seconds 5

Stop-Service -Name FMainSrv -Force -ErrorAction stop

Start-Sleep -Seconds 10

Start-Service -Name FMainSrv -Force -ErrorAction stop