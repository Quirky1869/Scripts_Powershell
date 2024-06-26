#requires -version 2.0

Function Get-GPSetting {

<#
.Synopsis
Get a GP Setting object
.Description
Get one or more group policy setting objects from a given container.
The command will return a collection of all settings or you can
specify one by name. Wildcards are permitted. 
.Parameter Container
A GPOSDK container object. Or you can pipe GPO object created from Get-SDMGpo.
.Parameter Path
The path to a GPO container
.Parameter GPO
A GPO object created with the Get-SDMGpo cmdlet.
.Parameter Name
A property name. 
.Example
PS C:\> $gpo | get-gpsetting -Path "user configuration\administrative templates\system" | select name

Name
----
Download missing COM components
Century interpretation for Year 2000
Restrict these programs from being launched from Help
Don't display the Getting Started welcome screen at logon
Prevent access to the command prompt
.Example
PS C:\> $system=get-gpcontainer -Path "user configuration\administrative templates\system" -gpo $gpo
PS C:\> $system | Get-GPSetting -Name "prevent*" | select name

Name
----
Prevent access to the command prompt
Prevent access to registry editing tools
.Example
PS C:\> Get-GPSetting $system -Name "prevent access to the command prompt"

Name                     GPsPath                  Parent                   Id
----                     -------                  ------                   --
Prevent access to the... \User Configuration\A... GPOSDK.GPContainerImpl
.Link
Get-GPContainer
Get-GPSettingProperty
#>

[cmdletbinding(DefaultParameterSetName="Object")]

Param(
[Parameter(Position=0,Mandatory=$True,
HelpMessage="What is the container object?",ParameterSetName="Object",
ValueFromPipeline=$True)]
[ValidateNotNullorEmpty()]
[GPOSDK.GpContainerImpl]$Container,

[Parameter(Position=0,Mandatory=$True,
HelpMessage="What is the container path?",ParameterSetName="Path",
ValueFromPipelineByPropertyName=$True)]
[ValidateNotNullorEmpty()]
[alias("GPSPath")]
[string]$Path,

[Parameter(Mandatory=$True,
HelpMessage="What is the GPO object?",ParameterSetName="Path",
ValueFromPipeline=$True)]
[GPOSDK.IGPObject]$GPO,

#wildcards are allowed
[Parameter(ParameterSetName="Path")]
[Parameter(ParameterSetName="Object")]
[Alias("Setting")]
[string]$Name

)

Begin {
    Write-Verbose "Starting $($myinvocation.mycommand)"
}

Process {
    If ($pscmdlet.ParameterSetName -eq "Path") {
        Write-Verbose "Getting settings from $path"
        $container=Get-GPContainer -path $path -gpo $GPO
     }
    else {
        Write-Verbose "Getting settings from $($container.name)"
    }
        $settings=$container.Settings    

} #process

End {

    if ($name) {
        #if $Setting display just that setting
        Write-Verbose "Getting setting $name"
        
        #is there a wildcard character?
        if ($name.Contains("*")) {
            $settings | Where {$_.name -like $name}
        }
        else {
            $settings | Where {$_.name -eq $name}
        }
    }
    else {    
        #otherwise list all of them
        $settings
    }
    Write-Verbose "Ending $($myinvocation.mycommand)"
}

} #End Get-GPSetting
