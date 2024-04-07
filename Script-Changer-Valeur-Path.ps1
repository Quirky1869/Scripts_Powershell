$oldPath = (Get-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH).path
$newPath = "$oldPath;C:\app\oracle\instantclient_10_2_32;"
Set-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH -Value $newPath