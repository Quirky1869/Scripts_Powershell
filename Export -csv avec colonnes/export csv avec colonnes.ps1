Get-Process | Export-Csv -Path 'c:\csv.csv'
$P = Import-Csv -Path 'c:\csv.csv'
$P