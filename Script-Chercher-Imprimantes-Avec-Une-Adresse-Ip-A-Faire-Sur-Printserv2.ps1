$internetProtocol = Read-Host "IP"
Get-Printer | select Name,PortName | where {$_.PortName -match $internetProtocol} | fl