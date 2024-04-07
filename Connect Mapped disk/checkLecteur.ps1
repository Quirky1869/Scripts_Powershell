$net = $(New-Object -ComOBject Wscript.Network)
$endl = "`n"
[console]::ForegroundColor = "white"
[console]::BackgroundColor = "black"
Clear-Host

$listePath = New-Object System.Collections.Generic.List[System.Object] #Creation de la liste contenant les lecteurs manquants afin de, plus tard, definir la liste des lecteurs a monté
$listeDrive = New-Object System.Collections.Generic.List[System.Object] #Creation de la liste contenant les lecteurs manquants afin de, plus tard, definir la liste des lecteurs a monté
$listeErreurPresence = New-Object System.Collections.Generic.List[System.Object] #Creation de la liste contenant les lecteurs manquants afin de, plus tard, definir la liste des lecteurs a monté
$listeErreurPresenceDrive = New-Object System.Collections.Generic.List[System.Object] #Creation de la liste contenant les lecteurs manquants afin de, plus tard, definir la liste des lecteurs a monté
$listeErreurMontage = New-Object System.Collections.Generic.List[System.Object] #Creation de la liste contenants les lecteurs manquants malgré la tentative de montage, afin d'etablir une liste d'erreur pour l'administrateur

$listePath.add("g:/") #Liste des chemins a verifier
$listePath.add("i:/") #Liste des chemins a verifier
$listePath.add("j:/") #Liste des chemins a verifier
$listePath.add("k:/") #Liste des chemins a verifier

$listeDrive.add("\\filer\forum$") #liste des chemin UNC
$listeDrive.add("\\filer\apps$") #liste des chemin UNC
$listeDrive.add("\\filer\adm$") #liste des chemin UNC
$listeDrive.add("\\filer\medical$") #liste des chemin UNC

#copie ces deux lignes au dessus jusq'a verifier TOUT les lecteurs
#listeDrive doit contenir UNIQUEMENT les chemins UNC qui pointent vers le serveurs


function verifierPresenceLecteur
{
  param($path)

  if($path.length -eq 1) #ajout de :\ si seulement la lettre est donné
  {
    $path = $path + ":\"
  }
  if($path.length -eq 2)
  {
    $path = $path + "\"
  }

  $pathExist = Test-Path -Path $path #test si le chemin d'acces existe et donc le lecteur
  Write-Host "Verification du lecteur " -NoNewLine
  Write-Host $path -ForegroundColor blue -NoNewLine
  write-Host " : " -NoNewline #Affichage
  informerResultat($pathExist)
  return $pathExist
}

function informerResultat
{
  param($resultat)
  if($resultat)
  {
    Write-Host "[" -NoNewLine
    Write-Host "OK" -ForegroundColor green -NoNewLine
    Write-Host "]"
  }
  else
  {
    Write-Host "[" -NoNewLine
    Write-Host "ERREUR" -ForegroundColor red -NoNewLine
    Write-Host "]"
  }
}

function monterLecteur
{
  param($path, $access)
  $letter = $path[0] #recupere la lettre associé au lecteur
#  $access = "\" + $path.split(":")[1] #recupere le chemin du dossier

  Write-Host "Ajout de " -NoNewLine
  Write-Host $path -ForegroundColor green
  Write-Host $letter $access
#  $net.MapNetworkDrive($letter,$access) #Montage du lecteur
  Write-Host "New-PSDrive -Name $letter -Root $access -Persist -PSProvider 'FileSystem'"
  New-PSDrive -Name $letter -Root $access -Persist -PSProvider "FileSystem" -Scope "Global"
}








for($i = 0;$i -LT $listePath.count; $i++) #Boucle for afin de verifier la presence de tout les lecteurs afin de definir une liste des lecteurs manquants pour le montage
{
  if(!(verifierPresenceLecteur $listePath[$i])) #si le lecteur est manquants (si $pathExist = $false)
  {
    $listeErreurPresence.add($listePath[$i]) #Ajout des lecteurs manquants a la liste
    $listeErreurPresenceDrive.add($listeDrive[$i])
  }
}

if($listeErreurPresence.ToArray().count -GT 0) #Si il y a des lecteurs manquants
{
  for($i=0;$i -LT $listeErreurPresence.ToArray().count;$i++) #boucle for afin de monter tout les lecteurs manquants
  {
    monterLecteur $listeErreurPresence[$i] $listeErreurPresenceDrive[$i]  #monte les lecteurs manquants
  }
  #Clear-Host

  for($i=0;$i -LT $listePath.count;$i++) #re-verifie tout les lecteurs afin d'etre sur et d'etablir une liste des manquants malgré les tentatives de montages des lecteurs
  {
    if(!(verifierPresenceLecteur $listePath[$i]))
    {
      $listeErreurMontage.add($listePath[$i]) #Ajout des lecteurs manquants a la liste
    }
  }
}
if($listeErreurMontage.ToArray().count -GT 0) #si des lecteurs sont manquants
{
  Write-Host $endl"[" -NoNewLine #demande a l'utilisateur d'avertir un adm
  Write-Host "ATTENTION" -ForegroundColor red -NoNewLine
  Write-Host "] " -NoNewLine
  Write-Host $listeErreurMontage.ToArray().count " ERREUR(S) DETECTE"$endl"CERTAINS LOGICIELS POURRAIENT NE PAS FONCTIONNER"$endl"VEUILLEZ LE SIGNALER A UN ADMINISTRATEUR"$endl$endl

  $table = New-Object system.Data.DataTable "Liste Lecteur Manquant" #creer une table nommé "Liste Lecteur Manquant"

  $col1 = New-Object system.Data.DataColumn "driveError" #creer une colonne nommé "driveError"

  $table.columns.add($col1) #ajoute la colonne a la table

  for($i=0;$i -LT $listeErreurMontage.ToArray().count;$i++) #pour tout les lecteurs manquants
  {
    $row = $table.NewRow() #creer une ligne
    $row.driveError = $listeErreurMontage[$i] #ajoute la valeur du lecteur manquant a la ligne

    $table.Rows.add($row) #ajoute la ligne a la table
  }
  Write-Host "Liste des erreurs : "
  $table | format-table -AutoSize #affiche la table


}
else #sinon rien, le script informe l'utilisateur que tout va bien, et le script s'eteint apres 10 Secondes
{
  Write-Host $endl"AUCUNE ERREUR DETECTE" -ForegroundColor green
}
