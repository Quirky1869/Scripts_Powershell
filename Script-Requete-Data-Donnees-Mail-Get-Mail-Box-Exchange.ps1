#Start-Transcript -Path "c:\temp\log-infomailbox.log" -Append

$userDsi = (Get-ADUser -Filter * -SearchBase "OU=DSI,OU=Agents,OU=Users,OU=CHA,DC=adcha,DC=local" -Properties *).SamAccountName

foreach($elements in $userDsi) 
{

Get-Mailbox -Identity "$($elements)" | select "samAccountName","PrimarySmtpAddress","Displayname","Database","OrganizationalUnit","TotalItemSize","WhenMailboxCreated"

Get-MailboxStatistics -Identity "$($elements)" | Select-Object LastLogonTime,lastlogofftime

Get-ADUser -Identity "$($elements)" -Properties * | select PwdLastSet 

#Clear-Variable elements


}


#Stop-Transcript