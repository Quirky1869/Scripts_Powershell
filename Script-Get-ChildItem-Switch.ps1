#=======================================Fermer fichier(s) ouvert(s)===========================================================#


# Destination du fichier .log
$destinationLog = (Get-ChildItem Env:\USERPROFILE).value + "\Net-file-close.log"

Start-Transcript -Path $destinationLog -Append


Write-Host "1 = Medical K:" -ForegroundColor Green -BackgroundColor Black
Write-Host "2 = Administration J:" -ForegroundColor Green -BackgroundColor Black
Write-Host "3 = Forum G:" -ForegroundColor Green -BackgroundColor Black
Write-Host "4 = Apps I:" -ForegroundColor Green -BackgroundColor Black
Write-Host "5 = Chemin UNC" -ForegroundColor Green -BackgroundColor Black


#$File#
$mappedDrives = Read-Host "Quel lecteur réseau"


Switch ($mappedDrives) 
{

    ### Medical K: ###

    ("1") {$pathMedical = Read-Host "Quel est votre chemin après \\filer.adcha.local\medical$\ "

    Get-ChildItem ('\\filer.adcha.local\medical$\' + $pathMedical)}

    ### Administration J: ###

    ("2") {$pathAdministration =  Read-Host "Quel est votre chemin après \\filer.adcha.local\adm$\ " 

    Get-ChildItem ('\\filer.adcha.local\Adm$\' + $pathAdministration)}

    ### Forum G: ###

    ("3") {$pathForum =  Read-Host "Quel est votre chemin après \\filer.adcha.local\forum$\ " 

    Get-ChildItem ('\\filer.adcha.local\forum$\' + $pathForum)}

    ### Apps I: ####

    ("4") {$pathApps = Read-Host "Quel est votre chemin après \\filer.adcha.local\apps$\ "

    Get-ChildItem ('\\filer.adcha.local\apps$\' + $pathApps)}

    ### Chemin UNC ###

    ("5") {$pathUnc =  Read-Host "Quel est votre chemin" 

    Get-ChildItem $pathUnc }



    default {break + (Write-Host "Arret du script" -ForegroundColor Magenta -BackgroundColor Black )}
}

Stop-Transcript