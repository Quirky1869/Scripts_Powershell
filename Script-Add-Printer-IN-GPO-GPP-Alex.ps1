﻿#Par defaut, utilise un input file
#$InputFilePath = "C:\temp\Inputfile.csv" #Read-Host "Provide the Path of the inputfile without ("")"
#$Inputlist = import-csv $InputFilePath



########################################
#On bascule sur de la selection manuelle
#Creation / Recuperation des variables
#On cherche les imprimantes voulues sur Printserv2 on affiche un menu de sélection:
$Groupes2 = Get-Printer -Name "Copieur*" -ComputerName "Printserv2"
$Menu2 = @{}
for ($Valeur2=1;$Valeur2 -le $Groupes2.count; $Valeur2++)
{Write-Host "$Valeur2= $($Groupes2[$Valeur2-1].Name)"
$Menu2.Add($Valeur2,($Groupes2[$Valeur2-1].Name))}
[int]$Choix2 = Read-Host "Choisir l'imprimante: "
#Detection de choix non null pour poursuivre
If($Choix2 -eq "0") {
Write-Host "[INFO] Aucun groupe de choisi, le poste ne sera pas ajoute a un groupe, Abort ..!" -ForegroundColor Red
}
Else {
#On enregistre la sélection du menu
$Selection2 = $Menu2.Item($Choix2)
Write-Host "[RECAP] On ajoute donc l'imprimante '$Selection2' a notre commande !" -ForegroundColor Yellow
pause
}

#On cherche les groupes AD et on affiche un menu de sélection:
$Groupes = Get-ADGroup -filter "name -like 'G_Ordinateurs*'" | Select Name,SID
$Menu = @{}
for ($Valeur=1;$Valeur -le $Groupes.count; $Valeur++)
{Write-Host "$Valeur= $($Groupes[$Valeur-1])"
$Menu.Add($Valeur,($Groupes[$Valeur-1]))}
[int]$Choix = Read-Host 'Choisir le Groupe AD: '
#Detection de choix non null pour poursuivre
If($Choix -eq "0") {
Write-Host "[INFO] Aucun groupe de choisi, le poste ne sera pas ajoute a un groupe, Abort ..!" -ForegroundColor Red
}
Else {
#On enregistre la sélection du menu
$Selection = $Menu.Item($Choix)
$GroupName = $Selection.Name
$GroupSID = Get-ADGroup -filter "name -like '$GroupName'" | Select SID #$Selection.SID.Value
Write-Host "[INFO] On ajoute donc le groupe '$GroupName' avec le SID '$GroupSID' a notre commande !" -ForegroundColor Yellow
pause
}


Write-Host "[INFO] Debut de l'execution de la commande de creation de l'imprimante dans la GPO !" -ForegroundColor Yellow
#Here We go !
#On rassemble les données recuperees et go
$Inputlist = @([pscustomobject]@{Name="$Selection2";UserContext="1";Path="\\Printserv2\$Selection2";GroupName="$Selection";GroupSID="$GroupSID";Action="U";GPOName="CHA Mappe Printers"})
$GPOName = $inputlist.GPOName |select -Unique
$FDRDatum = (Get-Date).tostring("yyyyMMdd")
# Provide Backup Folder path, the script will create a sub folder with current date.

$GPOBackupFDR = "C:\temp\$FDRDatum"

If(!(test-path $GPOBackupFDR))

    {
      New-Item -ItemType Directory -Path $GPOBackupFDR
        }

If (($GPOName).Count -eq 1)

    {
        $GPOID = Get-GPO $GPOName |select ID
        Backup-GPO $GPOName -path $GPOBAckupFDR
        # Provide the Network path of any DC to access the "Printer.xml" file. "Inly change the "\\DC01\d$\" as per your environment. Rest remains same.
        $GPP_PRT_XMLPath =  "\\DC1\c$\Windows\SYSVOL\domain\Policies\" + "{" + $GPOID.ID + "}" + "\User\Preferences\Printers\Printers-backup.xml"
        [XML]$PRNT = (Get-Content -Path $GPP_PRT_XMLPath)

            foreach ($e in  $Inputlist)

                {
                 $CurrentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                 $newguid = [System.Guid]::NewGuid().toString()
                 $NewEntry = $PRNT.Printers.SharedPrinter[0].Clone()
                 $NewEntry.Name = $e.Name
                 $NewEntry.Status = $e.Name
                 $NewEntry.Changed = "$CurrentDateTime"
                 $NewEntry.uid = "{" + "$newguid" + "}"
                 #$NewEntry.userContext = $e.UserContext
                 $NewEntry.properties.path = $e.Path
                 $NewEntry.properties.action = $e.action
                 $NewEntry.filters.Filtergroup.Name = $e.GroupName
                 $NewEntry.filters.Filtergroup.SID = $e.GroupSID
                 $PRNT.DocumentElement.AppendChild($NewEntry)
                }

            $PRNT.Save($GPP_PRT_XMLPath)
                  Write-Host "[INFO] Commande correctement executee, l'imprimante a ete ajoutee au groupe selectionne !" -ForegroundColor Green
           }

Else {Write-Host -ForegroundColor Red "ERROR: GPOName not unique"}
Write-Host "La fenetre va se fermer dans 4 secondes."
Start-Sleep 4