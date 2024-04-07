

Start-Transcript -Path "C:\Users\048710\Desktop\ipdispo.log"

$ip = get-content "C:\Users\048710\Desktop\ip17dispo.txt"


foreach($elements in $ip)
{


$testPing = (Test-NetConnection 192.168.11.$elements).PingSucceeded


        if($testPing -eq "False")
        {
            Write-Host "L'adresse 192.168.11.$($elements) est deja prise" -ForegroundColor Red
        }

        else
        {
            Write-Host "L'Adresse 192.168.11.$($elements) est dispo" -ForegroundColor Green
        }
 
}
Stop-Transcript



############################################ OU ##################################################

<#
$ip = get-content "C:\Users\048710\Desktop\ip17dispo.txt"

foreach($elements in $ip)

    {

    $testPing2 = Test-Connection -Count 1 192.168.11.$elements -Quiet

    if($testPing2)
    {

        Write-Host "L'adresse 192.168.11.$($elements) est disponible" -ForegroundColor Green

    }

    Else
    {

        Write-Host "L'adresse 192.168.11.$($elements) n'est pas disponible" -ForegroundColor Red

    }

    

    }

    #>