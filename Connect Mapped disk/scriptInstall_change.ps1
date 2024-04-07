$shell = New-Object -ComObject WScript.shell
[console]::ForegroundColor = "red"
[console]::BackgroundColor = "black"

$programOrigin ='\\sccm2012\sccm_repository$\Software\Scripts\CheckMappingNetworkDrive\checkLecteur.ps1' #Chemin d'acces a modifier pour télécharger le script checkLecteur.ps1
$programFolder = $env:USERPROFILE + "\script" #Dossier ou sera stocké le script
$programPath = $programFolder + "\checkLecteur.ps1" #Futur chemin d'acces du programm
mkdir $programFolder #création du dossier dans le dossier utilisateur
Move-Item -Path $programOrigin -Destination $programPath #déplacement du script


$linkPath = $env:APPDATA + "\Microsoft\Windows\Start Menu\Programs\Startup\checkLecteur.lnk" #Position du lien dans le startup UTILISATEUR (spécifique)
$link = $shell.CreateShortcut($linkPath) #Creation du lien
$link.TargetPath = $programPath #definition dans le lien de la direction du lien

$link.Save() #Sauvegarde du lien

start $linkPath #on demarre le script pour la premiere fois