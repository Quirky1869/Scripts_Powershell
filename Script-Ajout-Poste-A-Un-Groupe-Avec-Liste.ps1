#===================
#Script pour ajouter un poste à un groupe AD
#===================

 


#On cherche les groupes AD et on affiche un menu de sélection:
$Groupes = Get-ADGroup -Filter "name -like 'G_ordinateurs*'"                    
$Menu = @{}
for ($Valeur=1;$Valeur -le $Groupes.count; $Valeur++) 
{Write-Host "$Valeur= $($Groupes[$Valeur-1].name)" 
$Menu.Add($Valeur,($Groupes[$Valeur-1].name))}
[int]$Choix = Read-Host 'Choisir le Groupe AD'

 

#On enregistre la sélection du menu
$Selection = $Menu.Item($Choix)

 

#On recré les Distinguished Names:

#Identity:
$ADUserInfo = Get-ADComputer "$(Computer:TARGET)" -Properties *
$DistingName = $ADUserInfo.DistinguishedName
$Identity = $DistingName

#MemberOf:
$GroupName = 'G_ordinateurs*'
$DistingName2 = $ADGroupInfo.DistinguishedName

#2nd menu pour correspondance DistinguishedName avec Name du menu d'avant:
$Menu2 = @{}
$ADGroupInfo = Get-ADGroup -Filter "name -like 'G_ordinateurs*'"              
for ($Valeur2=1;$Valeur2 -le $ADGroupInfo.count; $Valeur2++)
{Write-Host "$Valeur2= $($ADGroupInfo[$Valeur2-1].distinguishedname)" 
$Menu2.Add($Valeur2,($ADGroupInfo[$Valeur2-1].distinguishedname))}
$Choix2 = $Menu2.Item($Choix)

 


#On ajoute le poste au groupe choisi:
Add-ADPrincipalGroupMembership -Identity:"$Identity" -MemberOf:"$Choix2" -Verbose

 

Write-Host ""
Write-Host "Le poste "$(Computer:TARGET)" a ete ajoute au Groupe AD '$Selection', OK!" -ForegroundColor Green
Write-Host ""

 


#Scan PDQ Inventory
Invoke-Command -ScriptBlock {pdqinventory ScanComputers -Computers "$(Computer:TARGET)" -ScanProfile "AD Infos"}