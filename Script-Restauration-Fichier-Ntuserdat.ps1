$int =[System.Object]::"257"

$userName = Read-Host "Entrez le nom d'utilisateur voulu" #(Get-ChildItem Env:\USERNAME).value
$cheminUsers = "\\filer\USERS$\$($userName)\profile\$($userName).V2\NTUSER.DAT"
$test = Get-ChildItem -Path $cheminUsers -Force -ErrorAction SilentlyContinue |
Select-Object @{Name="Taille-en-KB";Expression={$_.Length / 1Kb}}

$test

if ($test -ge $int)

{
    Write-Host "Le fichier Ntuser.dat est supérieur à 256 ko, inutile de le restaurer" -ForegroundColor Green
}

else

{
    Write-Host "Suppression fichier" -ForegroundColor Red
}