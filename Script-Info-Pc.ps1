# By : Micka
#======================================Paramètres pour demander le nom de l'ordi souhaité=====================================#

 Param(
  [Parameter(Mandatory=$True, helpmessage = " Entrez nom d'ordi ")]
   [string]  $Ordinateur = "$Env:ComputerName"
	
)

#$Ordinateur = Read-Host "Entrez le nom d'un PC"


#===============================================Déclaration des variables=====================================================#

# Destination par défaut
$Destination = (Get-ChildItem Env:\TEMP).value + "\AInfoPC.html" 

# Destination du fichier .log
$Destinationlog = (Get-ChildItem Env:\USERPROFILE).value + "\Log-info-PC\$($Ordinateur).log"

# Message Box
$Message = "L'ordinateur $($Ordinateur) n'a pas été trouvé ou ne ping pas"
$Titre = "Réessayer"
$btn = 1
$Icon = 16

#=======================================================Powershell============================================================#

try {

#Création du fichier Log
Start-Transcript -Path $Destinationlog -Verbose -Append

#Test connection
Test-Connection $Ordinateur -count 1

#Date de l'exécution du script
$Date = Get-WmiObject -Class Win32_LocalTime | Select Day,Month,Year,Hour,Minute,Second | ConvertTo-Html -Fragment

#Nom de l'ordi
$Name = Get-WmiObject -ClassName:CIM_ComputerSystem -ComputerName $Ordinateur | Select Name,PrimaryOwnerName,SystemType | ConvertTo-Html -Fragment

#UpTime de l'ordi
$Uptime = Get-WmiObject -Class:Win32_OperatingSystem -ComputerName $Ordinateur | Select CSname , @{LABEL='LastBootUpTime'; EXPRESSION={$_.Converttodatetime($_.lastbootuptime)}} | ConvertTo-Html -Fragment

#Constructeur et modèle de l'ordi
$Manufacturer = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Ordinateur | Select Manufacturer,Model | ConvertTo-Html -Fragment

#IP, Localisation, OS
$IP = Get-ADComputer $Ordinateur -Property * | Select IPv4Address,Description,OperatingSystem | ConvertTo-Html -Fragment

#OU de l'ordinateur
$OU = Get-ADComputer $Ordinateur -Property "CanonicalName" | Select "CanonicalName" | ConvertTo-Html -Fragment

#Disque Mappé
$Disk = Get-WmiObject -Class:Win32_MappedLogicalDisk -ComputerName $Ordinateur | Select Name,ProviderName | ConvertTo-Html -Fragment

#Disque local C: sur la machine
$Localdisk = (Get-WmiObject -Class:Win32_logicaldisk -ComputerName $Ordinateur) <#[0]#> | Select DeviceID,DriveType, @{Name="Taille disque GB";Expression={$_.size/1GB}}, @{Name="Espace libre GB";Expression={$_.FreeSpace/1GB}} | ConvertTo-Html -Fragment

#Imprimante présente sur l'ordi
$Printer = Get-WmiObject -Class:Cim_Printer -ComputerName $Ordinateur | Select Name | ConvertTo-Html -Fragment

#Mémoire physique présente sur l'ordi
$Memory = Get-WmiObject -ClassName:CIM_PhysicalMemory -ComputerName $Ordinateur | Select BankLabel, @{Name="Mémoire disponible GB";Expression={$_.Capacity/1GB}}, Manufacturer | ConvertTo-Html -Fragment

#Périphériques sur le poste
###$Device = Get-WmiObject -ClassName:CIM_UserDevice -ComputerName $Ordinateur | Select Name, Manufacturer | ConvertTo-Html -Fragment



Write-Host "Fin de l'execution du script, génération de la page HTML en cours ... " -ForegroundColor Green

}


catch {

break + ([System.Windows.Forms.Messagebox]::Show($Message, $Titre, $btn , $Icon )) +

 (Write-Host "Nom du pc erroné ou non trouvé" -ForegroundColor Red)

}

Stop-Transcript

#======================================================= CSS =====================================================#

$css = "<style type='text/css'>
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
  background-color:Green;
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

h2
{
 background-color:grey;
 width:15vw;
 margin-left:auto;
 margin-right:auto;
 color:blue;
 box-shadow: 0 8px 16px rgba(221,221,220,0.4), 0 8px 16px rgba(0,0,0,0.4) inset;
 border-radius:25PX;
 text-align:center;

}



</style>"


#===============================================Header HTML==================================================#


$header = "<title> Informations sur le PC </title>" + $css


#==================================================Corps CSS================================================#

$body = "<h2> Exécution du code pour l'ordi $($Ordinateur) le : </h2>" + $Date +

"<h3> Nom de l'ordi </h3>" + $Name +

"<h3> UpTime </h3>" + $Uptime +

" <h3> Constructeur </h3> " + $Manufacturer +

" <h3> IP                                                                  Localisation                                                             OS </h3> " + $IP +

"<h3> Unité d'Organisation  </h3> " + $OU +

"<h3> Disque local </h3>" + $Localdisk +

"<h3> Disque(s) </h3> "  + $Disk +

"<h3> Imprimante(s) </h3> " + $Printer +

"<h3> RAM </h3>" + $Memory  ###+

 ### "<h3> Périphériques </h3>" + $Device 
 

#==================================================Conversion en HTML=========================================#

ConvertTo-Html -Head $header -Body $body | Out-File -FilePath $($Destination)

Invoke-Item -Path $($Destination)