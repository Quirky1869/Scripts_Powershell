<##====================================================================Fonction(s)====================================================================##>

function avoirunpc

{

Param(
  [Parameter(Mandatory=$True, helpmessage = " Entrez nom d'ordi ")]
   [string] $ordinateur = "$env:computerName"
	
)
 

 $Ordi = Get-ADComputer $ordinateur -Properties * | ConvertTo-Html -Head "<h2> Info sur l'ordinateur </h2>" -Body "<h4> Informations </h4>" | Out-File -FilePath "\\srv-nas-info\users\mjacotet\mypowershell\HTML-Powershell\Resultatshtml\htmlpc.html"


 Invoke-Item -Path "\\srv-nas-info\users\mjacotet\Mypowershell\HTML-Powershell\Resultatshtml\htmlpc.html" 

}

<##===============================================================Appel de la fonction=======================================================================##>

avoirunpc