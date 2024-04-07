$namePc = (Get-ADComputer -Filter *).name

#$namePc = Get-Content -Path "C:\users\048710\desktop\namepc.csv"

foreach($elements in $namePc)
{
    
    Get-WmiObject Win32_OperatingSystem -ComputerName $elements -ErrorAction SilentlyContinue | Select PSComputerName,Caption,OSArchitecture | Where-Object {$_.Caption -match "Microsoft Windows 7 Entreprise"} |sort-object OSArchitecture
    Start-Sleep -Seconds 2

}

#Microsoft Windows 10 Professionnel
#Microsoft Windows 7 Professionnel