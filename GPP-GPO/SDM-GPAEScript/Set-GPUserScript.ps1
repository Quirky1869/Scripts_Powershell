#requires -version 2.0

Function Set-GPUserScript {
<#
.SYNOPSIS
Set a user script setting
.DESCRIPTION
Set a user logon or logoff script setting. You must make sure the script
exists in the specified path
.PARAMETER ScriptPath 
The name or path to the script.
.PARAMETER ScriptType 
Specify Logon or Logoff
.PARAMETER ScriptParameters 
Optional parameters for the script
.PARAMETER Remove
Delete the specified script from the GPO
.PARAMETER GPO 
The GPO object for this setting.
.EXAMPLE
PS C:\> $gpo | Set-GPUserScript -ScriptType Logoff -ScriptPath test2.cmd -pass
#>

[cmdletbinding(SupportsShouldProcess=$False)]

Param (
[parameter(Mandatory=$True,HelpMessage="Enter a script type: Logon or Logoff")]
[ValidateSet("Logon","Logoff")]
[string]$ScriptType,
[parameter(Mandatory=$True,HelpMessage="Enter the script name")]
[ValidateNotNullOrEmpty()]
[string]$ScriptPath,
[string]$ScriptParameters,
[switch]$Remove,
[parameter(Mandatory=$True,HelpMessage="You need to specify a GPO object",
ValueFromPipeline=$True)]
[object]$GPO,
[switch]$Passthru
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
    
    $setting=get-gpcontainer -path "User Configuration/Windows Settings/Scripts/$scriptType" -gpo $gpo
    
    if ($Remove) {
        Write-Verbose "Removing script entry $scriptpath"
        $item=$setting.Get("Items") | where {$_.name -eq $scriptpath}
        $setting.PutEx([gposdk.propop]::PROPERTY_DELETE,"Items",$item)
    }
    else {    
        write-verbose "Creating a new script entry"    
        $se = new-object "GPOSDK.ScriptEntry"
        Write-Verbose "$Scriptpath $scriptparameters"
        $se.Name = $Scriptpath                
        $se.Parameters = $ScriptParameters        
        $setting.PutEx([GPOSDK.PropOp]"PROPERTY_APPEND", "Items", $se)
    }
    Write-Verbose "Saving setting"
    $setting.save()
}

End {
    if ($passthru) {
        $setting
    }
    Write-Verbose "Ending $($myinvocation.mycommand)"
 }
 
} #end set-GPUserScript function
