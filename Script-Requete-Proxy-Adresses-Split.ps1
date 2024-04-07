$contenu = Get-Content -Path "C:\Users\048710\Desktop\agents.txt"
$nomUtilisateur = $contenu
$pattern = "SMTP"



foreach($elements in $nomUtilisateur)
{

$proxyAdresses = Get-ADUser ($elements).Trim() -Properties * | Select proxyAddresses

 
$splited = $proxyAdresses.proxyAddresses -split ','

$result = $splited | Where-Object {$_ -cmatch $pattern} | Out-File -filePath "C:\Users\048710\Desktop\proxyaddresses.csv" -Append

#$result -split "SMTP:"


}