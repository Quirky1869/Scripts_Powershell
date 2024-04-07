Write-Host 'Entrez nom du PC voulu : ' -NoNewline -ForegroundColor Magenta
$ordi = Read-Host


Write-Host "1 = Supprimer la description" -ForegroundColor Green -BackgroundColor Black
Write-Host "2 = Ajouter ou changer la description" -ForegroundColor Green -BackgroundColor Black


$choix = Read-Host "Voulez vous supprimer la description (1) ou la changer (2)"


Switch ($choix)
{

    ("1") {Write-Host "Suppression de la description de l'ordinateur $($ordi)" -ForegroundColor Red -BackgroundColor Black

    Set-ADComputer $ordi -clear:description }


    ("2") { $description = Read-Host 'Entrez la description voulu' 
            Set-ADComputer $ordi -replace:@{"description"="$($description)"}

            Write-Host "Changerment de la description de l'ordinateur $($ordi) effectué" -ForegroundColor Cyan -BackgroundColor Black
          }


    default {break + (Write-Host "ERREUR !!! Arret du script" -ForegroundColor Red -BackgroundColor Black)}


}