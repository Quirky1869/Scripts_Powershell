function Get-MTUserPasswordPolicy ($Identity)
{
$Fgpp = (Get-ADUserResultantPasswordPolicy -Identity $Identity).Name
[string]$Policy = switch ($Fgpp)
{
$null {"Default Domain Policy"}
{!($null)} {$Fgpp}
}

$Return = New-Object -TypeName PSObject
$Return | Add-Member -MemberType NoteProperty -Name Identity -Value $Identity
$Return | Add-Member -MemberType NoteProperty -Name PasswordPolicy -Value $Policy

return $Return
}

$countUser=0


Get-ADUser -Filter {Enabled -eq $True} | ForEach-Object {



$Pass=Get-MTUserPasswordPolicy -Identity $_.SamAccountName
If($Pass.PasswordPolicy -match "Default Domain Policy"){
<#Write-Host "L'utilisateur"#> $_.SamAccountName <#"n'a pas le groupe G_PWD_POLICY"#> | Out-File -Force C:\temp\no-Pwd-policy.txt -Append

$countUser++

}
  }

Write-Output $countUser "utilisateurs ne sont pas dans le groupe AD G_PWD_POLICY" | Out-File C:\temp\no-Pwd-policy.txt -Append