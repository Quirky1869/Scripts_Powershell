$fichier = $env:USERPROFILE + "\desktop\index.html"
$fichiertxt = $env:USERPROFILE + "\desktop\index.txt"

$imprimante = Get-WmiObject win32_printer | select Name,ShareName | ConvertTo-Html -Fragment
$os = Get-WmiObject cim_operatingsystem | select SystemDirectory,RegisteredUser | ConvertTo-HTML -Fragment
$css = "<style type='text/css'>
body
{
  background-color: #222222;
  color:whitesmoke;
}
table
{
  width:90vw;
  margin-right:auto;
  margin-left:auto;
}
td
{
  background-color:grey;
  width:50vw;
  text-align:center;
  border-radius:25PX;
  box-shadow: 0 8px 16px rgba(128,92,0,0.3) inset;
}

td:nth-child(odd)
{
  background-color:red;
}

 h3
 {
  color:white;
  text-align: center;
  width:90vw;
  margin-right:auto;
  margin-left:auto;
  background-color:black;
  border-radius:25PX;
  box-shadow:  0 8px 16px rgba(221,221,220,0.4) inset;

 }

</style>"
$header = "<title> Informations sur le PC : $($ordinateur)</title>" + $css

$body = "<h3> Imprimante </h3>" + $imprimante + "<h3> Operating System </h3> "  + $os

ConvertTo-Html -Head $header  -Body $body | Out-File -FilePath $fichier

Invoke-Item -Path $fichier