#requires -version 2.0

Function Get-GPItem {

<#
.Synopsis 
Get _ITEMS from a GPO setting
.Description
Some GPO settings have a property called _ITEMS which identifies possible
setting values. This command will help enumerate that property.
.Parameter Setting
A GPO SDK Setting object
.Example
PS C:\> $setting=$gpo | get-gpsetting -path "Computer Configuration/Administrative Templates/Windows Components/Windows PowerShell/" -name "Turn on Script Execution"
PS C:\> $setting | Get-GPItem

Value                             FriendlyName                     InternalName
-----                             ------------                     ------------
                                  Allow only signed scripts        AllScriptsSigned
                                  Allow local scripts and remot... RemoteSignedScripts
                                  Allow all scripts                AllScripts
                                                                                    
.Link
Get-GPSetting
Get-GPSettingProperty
Get-GPSettingPropertyType
#>

[cmdletbinding()]

Param (
[Parameter(Position=0,ValueFromPipeline=$True)]
[ValidateNotNullorEmpty()]
[GPOSDK.IGPSetting]$Setting
)

Begin {
 	Write-Verbose "Starting $($myinvocation.mycommand)"
 	}

Process {
	Write-Verbose "Processing $($setting.Name)"
	
	$setting.GetPropertyNames() | where {$_ -match "_ITEMS"} | 
	 foreach {
	    Write-Verbose $setting.name
	   $Setting.get($_) | Select Value,*Name
	   } #foreach
} #process

End {
	Write-Verbose "Ending $($myinvocation.mycommand)"
}
} #Get-GPItem
