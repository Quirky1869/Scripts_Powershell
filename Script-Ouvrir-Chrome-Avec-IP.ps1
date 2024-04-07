$1 = "1"


while($1 -eq "1")
{

#Stop-Process -name chrome -ErrorAction SilentlyContinue

$ip = Read-Host "IP"

Start-Process chrome 192.168.11.$ip/addressbook.html 

#pause
}