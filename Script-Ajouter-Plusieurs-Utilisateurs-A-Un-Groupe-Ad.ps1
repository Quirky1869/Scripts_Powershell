$fichier = Get-Content -Path 'C:\Users\048710\Desktop\Liste-nom.txt'

foreach($elements in $fichier)

{

    Add-ADGroupMember -Identity "G_WIFI_Personnel_CHA" -Members $elements -Verbose

}