### http://perso-laris.univ-angers.fr/~delanoue/lprt/powershell/LPRT-TP1-2-3-20173-PowerShell.pdf ###

#TP1 : Administration windows – Powershell

#Exo 1 : Creéez un dossier « essai » qui contient 2 sous reépertoires et 100 fichiers dans chacun. 
new-item -path 'b:\essai' -ItemType "directory"

$1 = new-item -path 'b:\essai\sous-repertoire1' -ItemType "directory"
$2 = new-item -path 'b:\essai\sous-repertoire2' -ItemType "directory"

#1ere technique
1..100 | foreach { new-item -path b:\essai\sous-repertoire1\"exemple"$_.txt }
1..100 | foreach { new-item -path b:\essai\sous-repertoire2\$_.txt }

#2eme technique
$vari = 1..100 
foreach ($element in $vari )
{
    new-item -path b:\essai\sous-repertoire1\"test"$element.txt
}

# Exercice 2 : Ecrire une ligne de commande qui liste les fichiers d’un répertoire qui ont pour extension txt

Get-ChildItem -path b:\essai\sous-repertoire1 | where {$_.name -like '*.txt'}

# Exercice 3 : Ecrire une ligne de commande qui liste les fichiers d’un reépertoire dans l’ordre de dernière modification et qui affiche les autorisations de chacun des fichiers.

Get-ChildItem -path b:\essai\sous-repertoire1 | where {$_.name -like '*.txt'} | Sort-Object LastWriteTime

#Faire un Install-module NtfsSecurity avant de lancer la commande ligne 29
Get-ChildItem -path b:\essai\sous-repertoire1 -Recurse| where {$_.name -like '*.txt'} | Get-NTFSAccess #| select Account,AccessRights | fl

# Exercice 3 : Lancer trois fois le bloc note de Windows aà la main, puis écrire une ligne de commande qui tue tous les processus qui s’appellent « notepad ».

Stop-Process -Name notepad

# Exercice 4 : Ecrire un script qui ne contient que la commande ls. Exécuter ce script. Cela ne devrait pas fonctionner. Penser à modifier votre niveau d’exécution.
ls
# Exercice 5 : Ecrire un script qui, à partir d’un fichier texte qui contient des noms d’utilisateurs, creée un répertoire pour chaque utilisateur
$content = Get-Content -Path 'B:\essai\sous-repertoire1\exemple1.txt'

foreach ($item in $content) 
{
    
    New-Item -Path "B:\essai\sous-repertoire1\$item" -ItemType Directory

}



#TP2 - Acceàs espaces disponible aà distance - Signature de scripts

# Exercice 1 : Espace disque

# 1. Disques locaux :
#(a) La commande $elements = get-WmiObject Win32 LogicalDisk crée une instance de l’objet WMI.
$elements = get-WmiObject Win32_LogicalDisk

#(b) Quelles sont les méthodes et propriétés disponibles pour l’instance $elements[0]?
$element[0] | gm

#(c) Comment connaître l’espace disponible sur un disque ?
Get-PSDrive

#(d) Ecrire un script qui calcule l’espace libre de chaque disque logique.
(Get-WmiObject -Class:Win32_logicaldisk) <#[0]#> | Select DeviceID,DriveType,VolumeName, @{Name="Taille disque GB";Expression={$_.size/1GB}}, @{Name="Espace libre GB";Expression={$_.FreeSpace/1GB}}

# 2. Disques distants (Pensez à désactiver le pare-feu) :
#(a) Le script suivant a pour nom get-freespace :
param ($computer = ".", [switch]$total)
get-wmiobject -computer $computer win32_logicaldisk | tee-object -variable disques |
select-object @{e={$_.systemname};n="Système"}, @{e={$_.name};n="Disque"}, @{e={[math]::round($_.freespace/1GB,1)};n="Disponible (Go)"}
if ($total) 
{
    "‘nEspace Disponible Total sur $($disques[0].systemname):
    $([math]::round(($disques|measure-object freespace -sum).sum/1GB,1)) Go" 
}