$1 = Read-Host entrez IP

$1

if ($1 -match "^\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\b$")
{

Write-Host ip ok -ForegroundColor Green

}

else
{

Write-Host ip non ok -ForegroundColor Red

}