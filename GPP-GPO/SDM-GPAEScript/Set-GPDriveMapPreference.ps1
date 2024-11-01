#requires -version 2.0

Function Set-GPDriveMapPreference {

<#
.Synopsis
Add a new group policy drive map preference
.Description
This command will configure drive map preference. Use the -Action parameter
to control what you want to do. The default action is "Update", but you can
also "Delete","Create", or "Replace". Note that many of the properties are 
Booleans that have default values. Look at full command help.
.Parameter Container
A GPO SDK Container object
.Parameter Action
The valid values are "Update","Delete","Create", or "Replace".
If you use Delete, then all other settings are ignored.
.Parameter DriveLetter
The drive letter to use without the colon, e.g. H
.Parameter Description
Add a description or comment
.Parameter Location
The drive mapping UNC
.Parameter Label
Add a label to the drive mapping
.Parameter ItemLevelTargeting
Using Item Level Targeting. UNDER DEVELOPMENT
.Parameter ThisDrive
Controls the settign for Hide/Show this drive. Valid values are:
Hide, NoChange, Show
.Parameter AllDrives
Controls the settign for Hide/Show all drives. Valid values are:
Hide, NoChange, Show
.Parameter StopIfError
Stop processing items in this extension if an error occurs. The default is $False.
.Parameter UseOneLetter
By default the mapping is made to the specific letter. If this is set to $False
then the mapping will use the next available drive letter starting with the value
of -DriveLetter.
.Parameter Reconnect
Reconnect at logon. The default is $False.
.Parameter UseLoggedOnSecurityContext
Map the drive using the user's security context
.Parameter RemoveWhenNotApplied
Remove this item when it is no longer applied.
.Parameter ApplyOnce
Apply once and do not reapply.
.Example
PS C:\> $dm | Set-GPDriveMapPreference
Please enter a drive letter without the colon, like H: K
Please enter the UNC path: \\chi-db01\files
PS C:\> $dm | Get-GPSettingProperty


Stop if an error                              : False
Action                                        : 2
Label as                                      :
Use one Letter                                : True
Order                                         : 1
Reconnect                                     : False
This drive                                    : 0
Run in logged-on user’s security context      : False
Remove this item when it is no longer applied : False
Item-level targeting                          : {}
Apply once and do not reapply                 : False
Description                                   :
Disabled                                      : False
Drive Letter                                  : K
Location                                      : \\chi-db01\files
uid                                           : {c602a6ee-554c-449a-a8d0-7ee88d57f504}
All drives                                    : 0

Create a simple drive mapping with all defaults.
.Example
PS C:\> $dm | set-GPDriveMapPreference -DriveLetter X -Location "\\chi-fp01\extras" -description "Test Drive mapping" -UseLoggedOnSecurityContext $True -StopIfError $True -ApplyOnce $True
PS C:\> $dm.settings

Name                     GPsPath                  Parent                   Id
----                     -------                  ------                   --
X                        \User Configuration\P... GPOSDK.GPContainerImpl
PS C:\> $dm.settings | Get-GPSettingProperty


Stop if an error                              : True
Action                                        : 2
Label as                                      :
Use one Letter                                : True
Order                                         : 1
Reconnect                                     : False
This drive                                    : 0
Run in logged-on user’s security context      : True
Remove this item when it is no longer applied : False
Item-level targeting                          : {}
Apply once and do not reapply                 : True
Description                                   : Test Drive mapping
Disabled                                      : False
Drive Letter                                  : X
Location                                      : \\chi-fp01\extras
uid                                           : {b09ddeac-e214-4a3e-a44b-8110c7d53789}
All drives                                    : 0
.Link
Set-GPSettingProperty
#>
[cmdletbinding(SupportsShouldProcess=$True)]

Param (
[Parameter(Position=0,ValueFromPipeline=$True,Mandatory=$True)]
[ValidateNotNullorEmpty()]
[GPOSDK.GpContainerImpl]$Container,
[ValidateSet("Update","Delete","Create","Replace")]
[GPOSDK.EACTION]$Action="Update",
[string]$DriveLetter,
[string]$Description,
[string]$Location, 
[string]$Label,
[object]$ItemLevelTargeting,
[ValidateSet("Hide","NoChange","Show")]
[gposdk.draction]$ThisDrive="Nochange",
[ValidateSet("Hide","NoChange","Show")]
[gposdk.draction]$AllDrives="NoChange",
[Boolean]$StopIfError=$false,
[Boolean]$UseOneLetter=$true,
[Boolean]$Reconnect=$false,
[Boolean]$UseLoggedOnSecurityContext=$false,
[Boolean]$RemoveWhenNotApplied=$false,
[Boolean]$ApplyOnce=$false

)

Begin {
 	Write-Verbose "Starting $($myinvocation.mycommand)"
 }

Process {
	Write-Verbose "Configuring a drive mapping preference for $($container.name)"
    
    if ($Action -eq "Delete") {
        Write-Verbose "Deleting"
        $hash=@{"Action"="Delete"}
    }
    Else {
        Write-Verbose "Configuring action $Action"
        
        #verify there is a drive letter
        if (-not $DriveLetter) {
            $DriveLetter=Read-Host "Please enter a drive letter without the colon, like H"
        }
        if (-not $Location) {
            $Location=Read-Host "Please enter the UNC path"
        }
        Write-Verbose "Adding mapping for drive $DriveLetter"
    	$item=$container.Settings.AddNew($DriveLetter)
    	
    	#create a hash table of new properties
    	$hash=@{
    	   "Stop if an error"=$StopIfError
     		"Action"=$action
     		"Label as"=$Label
    		"Use one Letter"=$UseOneLetter
    		"Reconnect"=$Reconnect
    		"This drive"=$ThisDrive
    		"Run in logged-on users security context"=$UseLoggedOnSecurityContext
    		"Remove this item when it is no longer applied"=$RemoveWhenNotApplied
    		"Apply once and do not reapply"=$ApplyOnce
    		"Description"=$Description
            "Drive Letter"=$DriveLetter[0]  #this will trim off any trailing : 
    		"Location"=$Location
    		"All drives"=$AllDrives
    	}
    	
    	if ($ItemLevelTargeting) {
    		Write-Verbose "Adding item level targeting"
    	 	$hash.add("Item-level targeting",$ItemLevelTargeting)
    	}
    } #else
	#apply the hash to the new setting
	Set-GPSettingProperty -setting $item -PropertyTable $hash	
    
} #Process

End {
	Write-Verbose "Starting $($myinvocation.mycommand)"
}

} #end Set-GPDriveMapPreference
