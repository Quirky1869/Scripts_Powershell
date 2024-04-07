$i=5
Do {
Write-Host $i
$i--
[console]::beep(440,100)
Start-Sleep -m 1000
}
While ($i -ge 0)



Write-Host "fini" -ForegroundColor Green
