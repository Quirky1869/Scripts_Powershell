### Date Changement MDP ###

$nomUtilisateur = (Get-ADUser -Filter * | select SamAccountName).SamAccountName

foreach($nom in $nomUtilisateur)
{
(Get-ADUser $nom -Properties whenchanged).whenchanged

}

foreach($elements in $dateChangementMDP)
{
    
    Write-Host $elements

}