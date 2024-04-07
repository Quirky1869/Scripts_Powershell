$UserPassword = Read-Host –AsSecureString
New-LocalUser -Name cavaillon -Password $UserPassword -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword -Description "Compte local" -Verbose
Add-LocalGroupMember -Group 'Administrateurs' -Member ('cavaillon') –Verbose