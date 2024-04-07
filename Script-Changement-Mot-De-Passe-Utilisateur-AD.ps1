# Utiliser ISE (X86) pour VBS


#Installation du module

Cls
#Import-Module ActiveDirectory

Write-Host "Veuillez saisir le nom utilisateur : " -ForegroundColor Green -NoNewline
$utilisteur = Read-Host


<#$ObjVbScript = new-object -comobject MSScriptControl.ScriptControl
$ObjVbScript.language = "vbscript"

#Afficher une fenêtre de saisie pour récupérer le tout dans une variable
$ObjVbScript.addcode("function getInput() getInput = inputbox(`"Entrez le nom de l'utilisateur`") end function" )
$utilisateur = $ObjVbScript.eval("getInput") #>

#changement du mot de passe par 123456
Set-ADAccountPassword -Identity $utilisateur -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "12345" -Force)

#Création du log

<#Start-TSranscript -path ".\Bureau\log.rtf"
Write-Host "un petit echo" > Bureau/log.rtf 
Write-Output "Une simple sortie"
Write-Error "Ecrire avec des information d'`"erreur`""
Write-Verbose "Si tu veux plus d'information, le verbose tu dois utliser"
Stop-Transcript#>