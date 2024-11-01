#requires -version 2.0

Function New-GPAdvancedGroupSetting {
<#
.Synopsis
Create a new Advanced group Setting Object 
.Description
This command creates an AdvancedGroupSetting object which is used with folder redirection.
Specify a user name or group and the redirection Path.
.Parameter Principal
The name of the user or group in the format domain\name.
.Parameter Path
The UNC for the redirected folder for the principal
.Example
PS C:\> $hr=New-GPAdvancedGroupSetting "globomantics\chicago hr" "\\chi-fp01\redirect\hr"
PS C:\> $hr

UserSid                                           FolderPath
-------                                           ----------
S-1-5-21-2552845031-2197025230-307725880-1136     \\chi-fp01\redirect\hr
.Link
Set-GPFolderRedirection
#>
[cmdletbinding()]

Param(
[Parameter(Position=0,Mandatory=$true,
HelpMessage="Enter the username or group in the format domain\name")]
[ValidatePattern({^\w+\\\w+})]
[string]$Principal,
[Parameter(Position=1,Mandatory=$true,
HelpMessage="Enter the UNC path for the principal")]
[ValidatePattern({^\\\\\S+\\\S+})]
[string]$Path
)

Write-Verbose "Starting $($myinvocation.mycommand)"

Write-Verbose "Getting SID for $Principal"
#split the principal
$domain=$Principal.Split("\")[0]
$name=$Principal.Split("\")[1]

$account=Get-WmiObject -Class "Win32_Account" -filter "Domain='$Domain' AND name='$Name'" -property "SID"

if ($account) {
	Write-Verbose "Found $($account.caption)"
	Write-Verbose "Creating an empty object"
	$fde=New-Object gposdk.FolderRedirectionEntry
	
	Write-Verbose "Applying new properties"
	$fde.UserSID=$account.sid
	$fde.FolderPath=$Path
	
	write $fde
}
else {
	Write-Warning "Failed to find $Principal"
}

Write-Verbose "Ending $($myinvocation.mycommand)"

} #end New-GPAdvancedGroupSetting
