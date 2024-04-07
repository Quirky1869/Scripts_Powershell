############################Shutdown############################

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$heure = [Microsoft.VisualBasic.Interaction]::InputBox("Veuillez saisir les heures voulu :","Heures".ToUpper(), "")

$minute = [Microsoft.VisualBasic.Interaction]::InputBox("Veuillez saisir les minutes voulu :","Minutes".ToUpper(), "")

if($heure -eq "")
{

 break

}

elseif($minute -eq "")
{

 break

}

else
{
$nombreSecondes=(3600*$heure)+(60*$minute)

Shutdown /s /t $nombreSecondes
}