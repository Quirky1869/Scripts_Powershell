$namePc = Get-Content -Path "C:\Users\048710\Desktop\pc.txt"

foreach($elements in $namePc)

{ 
    
    Get-ADComputer $elements -Properties * | select Name,Description,MemberOf,CanonicalName | fl | Out-File -FilePath "c:\users\048710\desktop\resultats.txt" -Append
   
}