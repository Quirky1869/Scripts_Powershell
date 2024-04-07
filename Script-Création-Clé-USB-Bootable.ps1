diskpart
# (cette commande ouvrira l'outil "diskpart")
cd 'C:\Windows\System32'#\diskpart.exe'

$listDisk = list disk
# (repérez le N° attribué a votre clé usb dans la liste qui s'affiche)
Write-Host $listDisk

select disk 3
# (changez 3 par le N° correspondant a votre clé usb)

clean
# (ceci supprimera la partition présente)

create partition primary
# (création d'une nouvelle partition)

active
# (ceci rendra votre partition active pour lui permettre d'être "amorçable")

format fs=fat32 quick
# (formatage rapide en "fat32")

assign
# (pour attribuer une lettre a votre lecteur USB)

exit
# (pour quitter diskpart)

exit
# (pour fermer l'invite de commande)