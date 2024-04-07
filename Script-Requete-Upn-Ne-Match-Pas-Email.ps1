$contenu = Get-Content -Path "C:\Users\048710\Desktop\agents.txt"
$nomUtilisateur = $contenu




foreach($elements in $nomUtilisateur)
{

$mail = Get-ADUser ($elements).Trim() -Properties * | Select Mail
$upn = Get-ADUser ($elements).Trim() -Properties * | Select UserPrincipalName

    if(($mail).Mail -eq ($upn).UserPrincipalName)

        {

            Write-Host "upn ok " -ForegroundColor Green

            
        }

    else
        {

          Write-Host "upn ko " -ForegroundColor Red

          $upn.UserPrincipalName + ";" + $mail.Mail | Out-File -FilePath "C:\temp\Multiple-colonne.csv" -Append -Encoding ascii #Export-Csv -Path "C:\temp\Upn-non-egal-au-mail-OU-Agents.csv" -NoTypeInformation -Encoding ascii -Append


        }

}