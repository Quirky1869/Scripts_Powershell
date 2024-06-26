#requires -version 2.0

Function Set-GPFolderRedirection {
<#
.Synopsis
Create a folder redirection entry
.Description
This command will create a folder direction entry. You can create a basic configuration
where the value of -Path will apply to everyone. You can create an advanced configuration
by passing one or more AdvancedGroupSettings objects with -Advanced. These object are
created with New-GPAdvancedGroupSetting. You can opt to follow the redirection for Documents
if it has been created using -FollowDocuments. Or remove the setting with -NotConfigured.

The other parameters allow you to customize the overall behavior. Look at full help for 
more details.
.Parameter Setting
A GPO SDK Setting object
.Parameter Path
The UNC for basic folder redirection.
.Parameter NoExclusive
This controls if the user as exclusive rights. By default they do. Use
this parameter if you do NOT want the user to have exclusive rights.
.Parameter NoContentMove
This controls whether user content is moved to the new redirected folder.
The default is to move content. Use this parameter if you do NOT want
to move content.
.Parameter NoApplyW2K3
By default, the folder redirection will apply to Windows 2003 and earlier systems.
Use this parameter if you do NOT want that behavior.
.Parameter RedirectToLocal
The parameter controls the "redirect content back to local" when policy is removed. The
default is NOT to redirect content back.
.Parameter Advanced
Specify one or more advanced folder redirection setting objects created by the
New-GPAdvancedGroupSetting cmdlet.
.Parameter NotConfigured
Configure the folder redirection to Not Configured.
.Parameter FollowDocuments
Configure the folder redirection to follow the Documents folder redirection setting.
.Example
PS C:\> $fr

Name           : Folder Redirection
Parent         : GPOSDK.GPContainerImpl
GPObject       : GPOSDK.GPObjectImpl
GPsPath        : \User Configuration\Windows Settings\Folder Redirection
Containers     : {}
Settings       : {Application Data, Desktop, Start Menu, Documents...}
Provider       : GPOSDK.Providers.FolderRedirectionProvider
GPO            : GPOSDK.GPObjectImpl
ExtensionGUIDs : [{25537BA6-77A8-11D2-9B6C-0000F8080861}{88E729D6-BDC1-11D1-BD2A-00C04FB9603F}]

PS C:\> $fr | get-gpsetting -name documents | Get-GPSettingProperty


Behavior                   : Undefined
Redirection_BackOnRemoval  : False
Redirection_GrantExclusive : True
Advanced_GroupsSettings    :
Redirection_MoveData       : True
Basic_FolderPath           :
ApplyOnW2K3orBelow         : True

PS C:\> $fr | get-gpsetting -name documents | Set-GPFolderRedirection -Path "\\chi-fp01\redirect"
PS C:\> $fr | get-gpsetting -name documents | Get-GPSettingProperty


Behavior                   : 1
Redirection_BackOnRemoval  : False
Redirection_GrantExclusive : True
Advanced_GroupsSettings    :
Redirection_MoveData       : True
Basic_FolderPath           : \\chi-fp01\redirect
ApplyOnW2K3orBelow         : True

This example created a basic folder redirection for all users using the default settings.
.Example
PS C:\> $fr | get-gpsetting -name documents | Set-GPFolderRedirection -NotConfigured

Remove the redirection
.Example
PS C:\> $hr=New-GPAdvancedGroupSetting "globomantics\chicago hr" "\\chi-fp01\redirect\hr"
PS C:\> $it=New-GPAdvancedGroupSetting "globomantics\chicago IT" "\\chi-fp02\redirect\it"
PS C:\> $fr | get-gpsetting -name documents | Set-GPFolderRedirection -Advanced $hr,$it -RedirectToLocal
PS C:\> $fr | get-gpsetting -name documents | Get-GPSettingProperty

Behavior                   : 2
Redirection_BackOnRemoval  : True
Redirection_GrantExclusive : True
Advanced_GroupsSettings    : {S-1-5-21-2552845031-2197025230-307725880-1136, S-1-5-21-2552845031-21
                             97025230-307725880-1136, S-1-5-21-2552845031-2197025230-307725880-1133
                             }
Redirection_MoveData       : True
Basic_FolderPath           :
ApplyOnW2K3orBelow         : True

This creates an advanced setting and redirects content back upon removal.
.Link
New-GPAdvancedGroupSetting
Set-GPSettingProperty
#>

[cmdletbinding(SupportsShouldProcess=$True,DefaultParameterSetName="Basic")]

Param(
[Parameter(Position=0,ValueFromPipeline=$True,Mandatory=$True)]
[ValidateNotNullorEmpty()]
[GPOSDK.IGPSetting]$Setting,
[Parameter(Mandatory=$True,HelpMessage="Enter a basic folder path",
ParameterSetName="Basic")]
[string]$Path,
[Parameter(ParameterSetName="Basic")]
[Parameter(ParameterSetName="Advanced")]
[switch]$NoExclusive,
[Parameter(ParameterSetName="Basic")]
[Parameter(ParameterSetName="Advanced")]
[switch]$NoContentMove,
[Parameter(ParameterSetName="Basic")]
[Parameter(ParameterSetName="Advanced")]
[switch]$NoApplyW2K3,
[Parameter(ParameterSetName="Basic")]
[Parameter(ParameterSetName="Advanced")]
[switch]$RedirectToLocal,
[Parameter(ParameterSetName="Advanced")]
[switch]$xAdvanced,
[Parameter(Mandatory=$True,ParameterSetName="Advanced")]
[GPOSDK.FolderRedirectionEntry[]]$Advanced,
[Parameter(ParameterSetName="NotConfigured")]
[switch]$NotConfigured,
[Parameter(ParameterSetName="Follow")]
[switch]$FollowDocuments
)

Begin {
    Write-Verbose "Starting $($myinvocation.mycommand)"
}
Process {
    #what parameter set is being used
    Switch ($pscmdlet.ParameterSetName) {
    "Advanced" {
        Write-Verbose "Creating advanced settings"
        Write-Verbose "Adding folder entries"
        foreach ($entry in $Advanced) {
            Write-Verbose "..$($entry.FolderPath)"
            $setting.PutEx([GPOSDK.PROPOP]::PROPERTY_APPEND,"Advanced_GroupsSettings",$entry)
        }
        $setting.Save()
        $hash=@{
            Behavior=[GPOSDK.FolderRedirectionBehavior]::Advanced
            Redirection_BackOnRemoval=$RedirectToLocal -as [boolean]
            Redirection_GrantExclusive=-Not ($NoExclusive -as [boolean])
            Redirection_MoveData=-Not ($NoContentMove -as [boolean])
            ApplyOnW2K3orBelow=-Not ($NoApplyW2K3 -as [boolean])
         }
        } #advanced
    "Basic" {
        Write-Verbose "Creating basic settings"
        $hash=@{
            Behavior=[GPOSDK.FolderRedirectionBehavior]::Simple
            Basic_FolderPath=$Path
            Redirection_BackOnRemoval=$RedirectToLocal -as [boolean]
            Redirection_GrantExclusive=-Not ($NoExclusive -as [boolean])
            Redirection_MoveData=-Not ($NoContentMove -as [boolean])
            ApplyOnW2K3orBelow=-Not ($NoApplyW2K3 -as [boolean])
            }
        } #basic
     "Follow" {
        Write-Verbose "Setting redirection to follow Documents"
         $hash=@{
           Behavior=[GPOSDK.FolderRedirectionBehavior]::FollowParent
           ApplyOnW2K3orBelow=-Not ($NoApplyW2K3 -as [boolean])
           }
        }
     "NotConfigured" {
        Write-Verbose "Setting folder redirection to not configured"
        #remove advanced settings if found
        $entries=$music.GetEx("Advanced_GroupsSettings")
        if ($entries) {
            foreach ($item in $entries) {
                Write-Verbose "Clearing $item.FolderPath"
                $Setting.Putex([gposdk.propop]::PROPERTY_DELETE,"Advanced_GroupsSettings",$item)
            }
           $Setting.Save()
        }
        #set default values
        $hash=@{
            Behavior=[GPOSDK.FolderRedirectionBehavior]::Default
            Basic_FolderPath=$Null
            Redirection_BackOnRemoval=$False
            Redirection_GrantExclusive=$True
            Redirection_MoveData=$True
            ApplyOnW2K3orBelow=$True
        }
        } #not configured
     } #switch
    
    #pass the hash table and set the new values
    $Setting | Set-GPSettingProperty -PropertyTable $hash
      
} #process
End {
    Write-Verbose "Ending $($myinvocation.mycommand)"
}

} #Set-GPFolderRedirection function
