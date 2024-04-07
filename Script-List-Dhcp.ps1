<#------------------------------------------------------------------------------------------
- A script to look for a computer name in all dhcp servers in domain.                      -
- The script will loop through all dhcps identified by Get-DhcpServerInDC.                 -
- For some reason some of the servers identified fail to respond to Get-DhcpServerv4Scope. -
-                                                                                          -
-Tsvi Keren                                                                                -
------------------------------------------------------------------------------------------#>

#--------------------------elevate-----------------------------
cls
$work_dir = get-location | select -ExpandProperty Path
$work_dir = $work_dir + "\"
#run again with elevated permissions
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) 
    { 
    #Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -WorkingDirectory $work_dir -Verb RunAs; exit
    Start-Process powershell.exe -ArgumentList "-File $PSCommandPath", $work_dir -Verb RunAs 
    exit
    }
#--------------------------------------------------------------

#------------------prompt for computer name--------------------
$computername = read-host "enter computer name or part of it"
#$computername = "computername"
#--------------------------------------------------------------

#-----------------------search in domain-----------------------
#---loop through all dhcps
$dhcps = Get-DhcpServerInDC
foreach ($dhcp in $dhcps)
    {
    $hasscope = 0
    $dhcpname = (($dhcp.DnsName).Split("."))[0]
    try
        {
        $scopes  = Get-DhcpServerv4Scope -ComputerName $dhcpname
        $hasscope = 1
        }
    catch
        {
        $hasscope = 0
        }
    if ($hasscope -eq 1)
        {
        #---loop through scopes---
        foreach ($scope in $scopes)
            {
            #---search for computer name in scope---
            Get-DhcpServerv4Lease -ComputerName $dhcpname -ScopeId $scope.ScopeId | Where-Object {$_.hostname -like "*$computername*"} `
            | select-object @{l="Server";e={$dhcpname}}, @{l="Scope";e={$scope.ScopeId}}, IPAddress, ClientId, Hostname, AddressState, LeaseExpiryTime `
            | format-table -AutoSize

            #$leases = Get-DhcpServerv4Lease -ComputerName $dhcpname -ScopeId $scope.ScopeId | Where-Object {$_.hostname -like "*$computername*"} 
            #foreach ($lease in $leases)
            #    {
            #    write-host $dhcpname "`t" $scope.ScopeId  "`t" $lease.IPAddress "`t" $lease.ClientId "`t" $lease.Hostname "`t" $lease.AddressState "`t" $lease.LeaseExpiryTime
            #    }
            }
        }
    }
#--------------------------------------------------------------

#-----------------------wait for any key-----------------------
Read-Host "Press any key to continue"
#Write-Host "Press any key to continue ..."
#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
#--------------------------------------------------------------