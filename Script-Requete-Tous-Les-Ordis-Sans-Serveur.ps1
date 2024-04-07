# Enlever les commentaires # dans le filter pour que le script fonctionne

### ATTENTION ### Ne pas mettre de commentaires dans le -filter

Get-ADComputer -filter { 
      
   Name -notlike 'PING*'
   Enabled -eq $True -and
   OperatingSystem -notlike 'Windows Server*'
   
   } | Select Name | Sort-Object Name | Export-Csv "chemin-a-rentrer-manuellement-par-l'utilisateur" -NoTypeInformation