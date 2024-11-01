#requires -version 2.0

Function New-GPFunction {

<#
.Synopsis
Create a PowerShell function outline
.Description
This command will take a Group Policy setting and create the outline of an 
advanced function. The command goes through the setting object, gets the 
properties and builds a custom function depending on whether you want to get
or set values. The setting name is used as the function noun, with all spaces
and special characters removed. You may want to rename during the editing 
process.

When creating a SET function, the setting's properties are captured as they
are in the GPO and used as object properties. Any of these that have spaces or
special characters need to be enclosed. Thus something like this:

  $settingobject.IPv6 filter: = $IPv6Filter

Needs to be modified like this:

  $settingobject.'IPv6 filter:' = $IPv6Filter

The property names are turned into parameters with spaces and special characters
removed. Names with spaces are also turned into camel case.

.Parameter Setting
The GPO Setting object
.Parameter Action
What type of function do you want to create? The default is Get but you can
also create a Set function.

.Example
PS C:\> $p=$gpComputerPath | where {$_ -match "WinRM Service"}
PS C:\> $c=get-gpcontainer $p -gpo $gpo
PS C:\> $st=$c | get-gpsetting -name "allow automatic*"
PS C:\> new-gpfunction $st set | clip

This example gets the Group Policy container Computer Configuration/
Administrative Templates/Windows Components/Windows Remote Management 
(WinRM)/WinRM Service.  It then defines a variable $st for the Allow automatic
configuration of listeners setting. This setting is used as the basis for a new
PowerShell function that will be copied to the clipboard. You can then paste it
into the scripting editor of your choice.

The function will be called Set-AllowAutomaticConfigurationOfListeners it will 
need to be edited.

.Example
PS C:\> $gpo=Get-SDMGPO MyTestGPO
PS C:\> $path="\Computer Configuration\Windows Settings\Security Settings\Account Policies\Password Policy"
PS C:\> $cont=get-gpcontainer -Path $path -gpo $GPO
PS C:\> $cont.settings | foreach {
 new-gpfunction $_ Get | out-file c:\work\AccountPasswordFunctions.ps1 -append -Encoding ASCII
 new-gpfunction $_ SET | out-file c:\work\AccountPasswordFunctions.ps1 -append -Encoding ASCII
 }

These commands get the Password Policies container and then creates a GET and 
SET function for every setting. All of the functions are saved to a single file
which can then be edited and turned into a module.
.Link
New-GPCommand
#>

[cmdletbinding()]
Param(
[Parameter(Position=0)]
[ValidateNotNullOrEmpty()]
[Object]$Setting,
[Parameter(Position=1)]
[ValidateSet("Get","Set")]
[string]$Action="Get"
)

#build a new function name from the setting name and action
#Remove spaces from setting name and set to camel case

#regex to match on illegal characters
[regex]$rx="-|'|\?|’|:|\s"

$noun=-join ($setting.name.split() | foreach {
      "{0}{1}" -f $_[0].ToString().ToUpper(),$rx.Replace($_.substring(1),"")
     })

#Format action so first letter is upper case

$verb="{0}{1}" -f $action[0].ToString().ToUpper(),$action.substring(1)

$cmdname="{0}-{1}" -f $verb,$noun

$begin=@"
"@

$proccode=@"

#if `$GPO is a string get the GPO object
if (`$gpo -is [string]) {
    Write-Verbose "Retrieving GPO object for `$gpo"
    `$gpo=Get-SDMGPO -Displayname `$gpo
}
   
`$setting=Get-GPSetting -Path "$($setting.gpspath)" -Name "$($setting.name)" -gpo `$gpo
`$settingobject=`$setting | Get-GPSettingProperty

"@

If ($Action -eq "Get") {    
    
    $hash=@{GPO="object"}
    Write-Verbose "Adding GET code"
    
$proc2=@"

#display formatted results        
`$settingobject | Select-Object *,
 @{Name="Path";Expression={`$setting.GPSPath}},
 @{Name="Setting";Expression={`$setting.name}},
 @{Name="GPO";Expression={`$setting.parent.gpo.name}}

"@
    #add the new code
    $proccode+=$proc2
    $synopsis="Getting GPO Settings from $($setting.name)"
    $description="This command will retrieve GPO settings for $($setting.name) under $($setting.parent.parent.name)."
    
}
else {
    Write-Verbose "Adding SET code"
    
    #get property settings as a hash table
    $hash=$setting | Get-GPSettingPropertytype -ashash
    
$setvalues=@"
#Modify settings object with new values

"@
    
    $hash.keys | foreach {
       #clean up key name because it might have illegal characters and spaces
       $k=$_
       $var= -join ($k.split() | foreach {
        "{0}{1}" -f $_[0].ToString().ToUpper(),$rx.Replace($_.substring(1),"")
        })
       
        $setValues+="`$settingobject.$_ = `$$var `n"
    } #foreach key
    
    #add GPO as an object
    $hash.Add("GPO","object")
    
$proc2=@"
#THIS WILL NEED TO BE EDITED AND TESTED

$setValues

`$setting | Set-GPSettingProperty -PropertyObject `$settingobject
"@
    
    #add the new code
    $proccode+=$proc2
    $synopsis="Setting GPO Settings for $($setting.name)"
    $description="This command will set GPO settings for $($setting.name) under $($setting.parent.parent.name)."

}

$endcode=@"
"@

    If ($action -eq "Get") {
        New-GPCommand -Name $cmdname -Synopsis $synopsis -Description $description -NewParameters $hash -ProcessCode $proccode -BeginCode $begincode -EndCode $endcode
    }
    else {
        New-GPCommand -Name $cmdname -Synopsis $synopsis -Description $description -NewParameters $hash -ProcessCode $proccode -BeginCode $begincode -EndCode $endcode -ShouldProcess
    }
    
} #end function