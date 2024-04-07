﻿Import-Module MSOnline
$O365Cred = Get-Credential
$O365Session = New-PSSession –ConfigurationName Microsoft.Exchange `
                             -Credential $O365Cred `
                             -Authentication Basic `
                             -AllowRedirection
Import-PSSession $O365Session
Connect-MsolService –Credential $O365Cred