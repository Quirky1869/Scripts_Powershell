############################Shutdown############################

Write-Host "Entrez les heures : " -ForegroundColor Green -BackgroundColor Black -NoNewline

$heure = Read-Host

Write-Host "Entrez les minutes : " -ForegroundColor Cyan -BackgroundColor Black -NoNewline

$min = Read-Host

$nombreSecondes=(3600*$heure)+(60*$min)

Write-Host $nombreSecondes

Shutdown /s /t $nombreSecondes