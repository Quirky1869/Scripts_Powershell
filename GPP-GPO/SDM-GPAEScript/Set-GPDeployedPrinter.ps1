#requires -version 2.0

Function Set-GPDeployedPrinter {
<#
.SYNOPSIS
Set a deployed printer
.DESCRIPTION
This command will add or remove a deployed printer
.PARAMETER GPONode 
The GPO node to modify: User or Computer
.PARAMETER Name 
The name of the printer
.PARAMETER ServerName 
The print server name
.PARAMETER Remove 
Delete the printer by name from the GPO
.PARAMETER GPO 
The GPO object for this setting
.Example
PS C:\> $gpo | Set-GPDeployedPrinter -GPONode User -Name HPSales -ServerName \\myprint02 

#>

[cmdletbinding(SupportsShouldProcess=$False,DefaultParameterSetName="Add")]

Param (
[parameter(Mandatory=$True,HelpMessage="User or Computer?")]
[ValidateSet("User","Computer")]
[string]$GPONode,
[parameter(Mandatory=$True,HelpMessage="What is the printer name?")]
[ValidateNotNullorEmpty()]
[string]$Name,
[parameter(Mandatory=$True,HelpMessage="What is the server name?",
ParameterSetName="Add")]
[ValidateNotNullorEmpty()]
[string]$ServerName,
[Parameter(ParameterSetName="Delete")]
[switch]$Remove,
[switch]$Passthru,
[parameter(Mandatory=$True,HelpMessage="You need to specify a GPO object",
ValueFromPipeline=$True)]
[Object]$GPO
)

Begin {
    Write-Verbose "Starting $($myinvocation.mycommand)"
}

Process {
    #if $GPO is a string get the GPO object
    if ($gpo -is [string]) {
        Write-Verbose "Retrieving GPO object for $gpo"
        $gpo=Get-SDMGPO -Displayname $gpo
    }
    
    $container=get-gpcontainer -path "$Gponode Configuration/Windows Settings/Deployed Printers" -gpo $gpo
    Write-Verbose "Processing $($container.gpspath)"
    if ($remove) {
        Write-Verbose "Removing printer $name"
        $item=$container.Settings | where {$_.name -eq $name}
        #this change is immediate
        $container.Remove($item)
    }
    else {
        Write-Verbose "Adding $servername\$name"
        $print=$container.Settings.AddNew($Name)
        $print.Put("ServerName",$ServerName)
        Write-Verbose "Saving"
        $Print.Save()
        
        If ($Passthru) {
        $print
        }
    }
}

End {  
    Write-Verbose "Ending $($myinvocation.mycommand)"
 }
 
} #end Set-GPDeployedPrinter function
