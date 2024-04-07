$OU = #"OU=SAMU REGULATION - CENTRE 15,OU=Agents,OU=Users,OU=CHA,DC=adcha,DC=local"
$USERS= Get-ADUser -SearchBase $OU -Filter *
$group="G_PWD_POLICY"
Remove-ADGroupMember -Identity $group -Members $USERS