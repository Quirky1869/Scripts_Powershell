################################################# Ajout de la variable ""I:\Centura_Ellipse_2005;" au PATH ##########################################################

$oldPath = (Get-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH).path
$newPath = "I:\Centura_Ellipse_2005;$oldPath"
Set-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH -Value $newPath