#requires -version 2.0

Function New-GPCommand {
<#
.SYNOPSIS
Create an advanced function outline

.DESCRIPTION
This command will create the outline of an advanced function based on a
hash table of new parameter values. If the hash table contains keys with
spaces, they will be removed and text will be set to camel case. For example,
a key like:

 "Stop when going on batteries" 

will become:

 "StopWhenGoingOnBatteries" 

You will still need to flesh out the function and insert the actual commands.

.PARAMETER Name
The name of the new function

.PARAMETER NewParameters
A hash table of new parameter values. The key should be the parameter name. 
The entry value should be the object type. You can also indicate if it should 
be an array by using [] with the object type. Here's an example:

@{Name="string[]";Test="switch";Path="string"}

.PARAMETER ShouldProcess
Set SupportsShouldProcess to True in the new function.

.PARAMETER Synopsis
Provide a brief synopsis of your command. Optional.

.PARAMETER Description
Provide a description for your command. You can always add and edit this later.

.PARAMETER BeginCode
A block of code to insert in the Begin scriptblock.

.PARAMETER ProcessCode
A block of code to insert at the start of the Process scriptblock.

.PARAMETER EndCode
A block of code to insert at the start of the End scriptblock.

.PARAMETER UseISE
If you are running this command in the ISE, send the new function to
the editor.

.EXAMPLE
PS C:\> $paramhash=@{Name="string[]";Test="switch";Path="string"}
PS C:\> New-GPCommand -name "Set-GPScript" -Newparameters $paramhash | out-file "c:\scripts\set-gpscript.ps1"

Create an advanced script outline for Set-GPScript with parameters of Name, Test
and Path. Results are saved to a file. 
.EXAMPLE
PS C:\> $mypath=$gpComputerPath | where {$_ -match "Password Policy"}
PS C:\> $cont=Get-GPContainer -Path $mypath -gpo $gpo

This gets the Password Policy container.
PS C:\> $cont


Name           : Password Policy
Parent         : GPOSDK.GPContainerImpl
GPObject       : GPOSDK.GPObjectImpl
GPsPath        : \Computer Configuration\Windows Settings\Security Settings\Account Policies\Passwo
                 rd Policy
Containers     : {}
Settings       : {Minimum password length, Maximum password age, Enforce password history, Store pa
                 sswords using reversible encryption...}
Provider       : GPOSDK.Providers.AccountPolicyProvider
GPO            : GPOSDK.GPObjectImpl
ExtensionGUIDs : [{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]

Next, we'll get the setting properties for one of the password properties since
they are all basically the same. We can create a single function that can be applied
to all of them.

PS C:\> $hash=$cont | get-gpsetting -name "Maximum password age" | get-gpsettingpropertytype -ashash
PS C:\> $hash

Name                           Value
----                           -----
Value                          System.Int32
Defined                        System.Boolean

We know we're going to need a GPO to modify so we'll add that to the hash table
assuming the user of this function will have a predefined GPO object.

PS C:\> $hash.Add("GPO","GPOSDK.GPObjectImpl")

PS C:\> $hash

Name                           Value
----                           -----
Value                          System.Int32
GPO                            GPOSDK.GPObjectImpl
Defined                        System.Boolean

Finally, we're ready to create the new command, adding support for ShouldProcess,
a synopsis and brief description. The result is sent to a file which we can edit.

PS C:\> new-gpcommand -name Set-PasswordSetting -NewParameters $hash -ShouldProcess -Synopsis "Configure password setting" -Description "Configure one of the password setting policies like maximum password age." | out-file c:\scripts\Set-PasswordSetting.ps1

If we want, we can open the ISE and edit the file.

PS C:\> ise c:\scripts\Set-PasswordSetting.ps1

The New-GPCommand command takes a lot of the grunt work out of the process so you can
focus on the actual working part of the function.
.LINK
Get-GPSettingProperty
Get-GPSettingPropertyType
New-GPFunction
about_gpae_new_gpcommand

#>

[cmdletbinding()]

Param(
[Parameter(Mandatory=$True,HelpMessage="Enter the name of your new command")]
[ValidateNotNullorEmpty()]
[string]$Name,
[hashtable]$NewParameters,
[switch]$ShouldProcess,
[string]$Synopsis,
[string]$Description,
[string]$BeginCode,
[string]$ProcessCode,
[string]$EndCode,
[switch]$UseISE

)
Write-Verbose "Starting $($myinvocation.mycommand)"
#add parameters
$myparams=""
$helpparams=""
$originalParams=@{}
Write-Verbose "Processing parameter names"
foreach ($k in $NewParameters.Keys) {
    Write-Verbose "  $k"
    [string]$originalkey=$k
    $paramtype=$NewParameters.item($k)
    #reformat key if it has spaces or illegal characters
    [regex]$rx="$([char]8217)|'|\?|-|:"
    if ($rx.match($k)) {
        Write-Verbose "...Parsing out illegal characters"
        $k=$rx.replace($k,"")
    }
    
    if ($k -match "\s") {
        Write-Verbose "...Reformatting for spaces"
        
        $trimmed = -join ($k.split() | foreach {
        "{0}{1}" -f $_[0].ToString().toUpper(),$_.substring(1)
        } )
        
        write-verbose "...$trimmed"
        $originalParams.Add("$originalkey",$trimmed)
        $k=$trimmed
    } #if spaces
    
    $item="[{0}]`${1}" -f $paramtype,$k
    Write-Verbose "Adding $item to myparams"
    $myparams+="$item, `n"
    $helpparams+=".PARAMETER {0} `n`n" -f $k
}

#get trailing comma and remove it
$myparams=$myparams.Remove($myparams.lastIndexOf(","))

Write-Verbose "Building text"
$text=@"
Function $name {
<#
.SYNOPSIS
$Synopsis

.DESCRIPTION
$Description

$HelpParams

.NOTES
These are the original parameter names. Some may have been modified.
Depending on encoding any ? might really be a curly apostrophe.

$($NewParameters.Keys | out-string)
#>

[cmdletbinding(SupportsShouldProcess=`$$ShouldProcess)]

Param (
$MyParams
)

Begin {
    Write-Verbose "Starting `$(`$myinvocation.mycommand)"
    Import-Module SDM-GroupPolicy,GPAE
    $BeginCode
}

Process {
    $ProcessCode
}

End {
    $EndCode
    Write-Verbose "Ending `$(`$myinvocation.mycommand)"
 }
 
} #end $name function

"@

if ($UseISE -and $psise) {
    $newfile=$psise.CurrentPowerShellTab.Files.Add()
    $newfile.Editor.InsertText($Text)
}
else {
    Write $Text
}

Write-Verbose "Ending $($myinvocation.mycommand)"
} #end New-GPCommand function
