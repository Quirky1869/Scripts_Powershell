$UserLanguageList = New-WinUserLanguageList -Language "fr-FR"
$UserLanguageList.add("fr-FR")
Set-WinUserLanguageList -LanguageList $UserLanguageList

#Link : https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-input-locales-for-windows-language-packs
#link2 : https://docs.microsoft.com/en-us/powershell/module/international/Set-WinUserLanguageList?view=win10-ps
#Link3 definir clavier/langue par défaut : https://www.tenforums.com/tutorials/102923-set-default-keyboard-input-language-windows-10-a.html (Set-WinUserLanguageList -LanguageList en-US -Force)