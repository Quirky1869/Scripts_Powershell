<##====================================================================Functions====================================================================##>

function avoirlesservices

{
 $Date = get-date -format yyyy-MM-dd_HH:mm:ss

 # Destination par défaut
 $Destination = (Get-ChildItem Env:\TEMP).value + "\Get-services.html"


 $Services =Get-Service | select name,status  | Sort-Object status  -Descending  | ConvertTo-Html -Fragment

 $Css = "<style type='text/css'>

 body
{
  
  background-color: #222222;
  color:White;
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
  box-shadow: 0 8px 16px rgba(221,221,220,0.4) inset;
}

td:nth-child(odd)
{
  background-color:darkgreen;
  text-align:center;
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


 $Head = "<title> Get-services </title>" + $Css

 $Body = "<h3> Heure de l'execution du script </h3>" + $Date +
 
 "<h3> Voici les services en cours et arreter sur votre ordinateur<h3/>" + $Services


  foreach ($service in $services)
  
{ if

  ($service.status -eq "running" ) { Write-Host " Le service $($service.name) est : $($service.status)" -ForegroundColor green }

  elseif

  ($service.status -eq "stopped") { Write-Host " Le service $($service.name) est : $($service.status)" -ForegroundColor red } 


}


ConvertTo-Html -Head $Head -Body $Body | Out-File -FilePath $($Destination)


Invoke-Item -Path $($Destination) }

<##===============================================================Appel de la fonction=======================================================================##>


avoirlesservices