# Get the cumulative size of all user profiles on the system in MB

$Sum = [math]::Round(
  (
    (
      (
        Get-ChildItem -Path "\\home.adcha.local\USERS$\$env:username" |
        ForEach-Object {
          Write-Host "Analyse du dossier : $($_.FullName)" -ForegroundColor Green ;
          Get-ChildItem -Path $_.FullName -Recurse -File -ErrorAction SilentlyContinue } | Measure-Object -Property Length -Sum).Sum)/1MB
    )
)
write-Host "Nombre de fichiers contenus dans le dossier utilisateur de $env:username : " -NoNewline -ForegroundColor Cyan
@(Dir \\home.adcha.local\USERS$\$env:username).Count 
write-Host "Taille totale des données contenus dans le dossier utilisateur de $env:username : " -ForegroundColor Cyan -NoNewline
Write-Host "$Sum MB"
Write-Host "Chemin analysé : " -ForegroundColor Cyan -NoNewline
Write-Host "\\home.adcha.local\USERS$\$env:username"