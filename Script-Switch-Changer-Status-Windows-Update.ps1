Write-Host "1 = Ajouter les feux de depart" -ForegroundColor Green -BackgroundColor Black
Write-Host "2 = Enlever les feux de depart" -ForegroundColor DarkRed -BackgroundColor Black



$choix = Read-Host "Voulez vous sajouter les feux de depart (1) ou les enlever (2)"


Switch ($choix)
{

    ("1") {Write-Host "Ajout des feux de depart" -ForegroundColor Green -BackgroundColor Black
    
        sl "D:\Telechargements Gaming\_Download\AC"
        Copy-Item -Path ".\off.png" -Destination "G:\Steam-M2\steamapps\common\assettocorsa\content\texture" -Force

     }


    ("2") { Write-Host "Suppression des feux de départ" -ForegroundColor DarkRed -BackgroundColor Black

      sl "G:\Steam-M2\steamapps\common\assettocorsa\content\texture"
    Remove-Item -Path ".\off.png"

          }


    default {break + (Write-Host "ERREUR !!! Arret du script" -ForegroundColor Red -BackgroundColor Black)}


}