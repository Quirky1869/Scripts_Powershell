$1 = Read-Host entrez IP

$1

if ($1 -match "^(\d{1,3}\.){3}\d{1,3}$")
{

Write-Host ip ok -ForegroundColor Green

}

else
{

Write-Host ip non ok -ForegroundColor Red

}