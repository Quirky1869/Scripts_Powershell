$chemin = "DECLARER VOTRE CHEMIN"
(Get-Content $chemin) | Foreach-Object {$_ -replace ".{2}$"} #| Out-File -FilePath $chemin -Force