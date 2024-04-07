Get-ADComputer -Filter "OperatingSystem -like 'Windows*'" -Properties OperatingSystem | Group-Object OperatingSystem | Sort-Object Count | Export-Csv -Path 'c:\xp.csv' -Force -NoTypeInformation
$csv = Import-Csv -Path 'c:\xp.csv'
$csv
Invoke-Item -Path 'c:\xp.csv'