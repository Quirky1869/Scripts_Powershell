#requires -version 2.0

Function Remove-GPPreferenceSetting {
<#
.Synopsis
Delete a Group Policy preference setting
.Description
Use this command to delete a Group Policy Setting preference setting.
.Parameter Container
A GPO SDK Container object.
.Parameter Name
The name of the preference setting. 
.Example
PS C:\> $dm | Remove-GPPreferenceSetting -Name X
.Link
Set-GPDrivePreferenceSetting
Get-GPSetting
#>
[cmdletbinding(SupportsShouldProcess=$True)]

Param(
[Parameter(Position=0,ValueFromPipeline=$True,Mandatory=$True)]
[ValidateNotNullorEmpty()]
[GPOSDK.GpContainerImpl]$Container,
[Parameter(Position=1,Mandatory=$True,
HelpMessage="What is the name of the preference setting to delete?")]
[string]$Name
)

Begin {
    Write-Verbose "Starting $($myinvocation.mycommand)"   
}

Process {
    Write-Verbose "Getting setting $Name from $($Container.GPSPath)"
    $setting=Get-GPSetting -Container $Container -Name $Name
    if ($Setting) {
        Write-Verbose "Deleting setting"
        if ($pscmdlet.ShouldProcess($name)) {
            $Setting.Delete()
        }
    }
    else {
        Write-Error "Failed to find a setting called $Name"
    }
}
End {
    Write-Verbose "Ending $($myinvocation.mycommand)"   
}

} #end Remove-GPPreferenceSetting
