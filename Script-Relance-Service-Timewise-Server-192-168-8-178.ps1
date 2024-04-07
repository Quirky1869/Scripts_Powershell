### Stop service TW Web 192.168.8.178 ###

Stop-Process -ProcessName TWWeb -Force -ErrorAction SilentlyContinue

Start-Sleep -Seconds 5

Stop-Service -Name FMainSrv -Force -ErrorAction stop

Start-Sleep -Seconds 10

Start-Service -Name FMainSrv -Force -ErrorAction stop