$RAM1 = Get-WmiObject -ClassName:Cim_PhysicalMemory  | ? -Property BankLabel -EQ 'BANK 0' | select -ExpandProperty Capacity

$R1 = [Math]::Round($RAM1 / 1GB, 2)

 
 $RAM2 = Get-WmiObject -ClassName:Cim_PhysicalMemory  | ? -Property BankLabel -EQ 'BANK 1' | select -ExpandProperty Capacity

$R2 = [Math]::Round($RAM2 / 1GB, 2)


$RAM3 = Get-WmiObject -ClassName:Cim_PhysicalMemory   | ? -Property BankLabel -EQ 'BANK 2' | select -ExpandProperty Capacity 

$R3 = [Math]::Round($RAM3 / 1GB, 2) 

 

$Total = $R1+$R2+$R3

 

Write-Host "$Total GB/RAM"
