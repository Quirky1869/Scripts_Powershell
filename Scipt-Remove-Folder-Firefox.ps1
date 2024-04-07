$nomUtilisateur = (Get-ChildItem -Path "\\filer\users$" -Directory).Name

foreach($elements in $nomUtilisateur)
{

$enddate=[datetime]::ParseExact("14-10-2021 23:59","dd-MM-yyyy HH:mm",$null)


Get-ChildItem -Path "\\filer\users$\$($elements)\firefox\*" | Where-Object {$_.CreationTime -lt $enddate} | Remove-Item -Recurse -Exclude "0 - Template" -WhatIf


}