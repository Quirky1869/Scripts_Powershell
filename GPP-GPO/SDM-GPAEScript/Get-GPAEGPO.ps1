#requires -version 2.0

Function Get-GPAEGPO {
<#
.Synopsis
Get a Group Policy Object
.Description
This is a simplified version of the Get-SDMGPObject cmdlet. The benefit is that
it defaults to the local domain. All you have to do is specify a GPO name. Almost
all of the functions in the Group Policy Automation Engine SDK module require a 
GPO object.
.Parameter GPO
The GPO Name such as "Default Domain Policy"
.Parameter Domain
The domain for the GPO. The default is the domain for the current user.
Specify the domain name as a FQDN.
.Parameter CentralStore
Enter the path if used.
.Parameter Credential
Specify a saved PSCredential variable if you need alternate authentication
.Example
PS C:\> $gpo=Get-GPAEGpo "Default Domain Policy"
.Example
PS C:\> $gpo=get-gpo -all | where {$_.displayname -match "Remoting"} | get-gpaegpo

This gets the GPO from the domain that has Remoting in the name. It is assumed 
there is only one such GPO.
#>

[cmdletbinding()]

Param(
[Parameter(Position=0,Mandatory=$True,Helpmessage="Enter the name of a GPO",
ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
[alias("Name")]
[ValidateNotNullorEmpty()]
[string]$Displayname,
[string]$Domain=$env:USERDNSDOMAIN,
[string]$CentralStore,
[System.Management.Automation.PSCredential]$Credential
)

#create base command
Write-Verbose "Getting GPO $displayname from $Domain"
$cmd="Get-SDMgpobject -GpoName 'gpo://{0}/{1}' -OpenByName" -f $domain,$displayname

if ($CentralStore) {
    Write-Verbose "Connecting to $CentralStore"
    $cmd+=" -Centralstore $CentralStore"
}

if ($Credential) {
    Write-Verbose "Using alternate credentials"
    $cmd+=(" -username {0} -password {1}" -f $credential.GetNetworkCredential().Username,$credential.GetNetworkCredential().Password)
}

Write-Verbose "Executing: $cmd"
Invoke-Expression -Command $cmd

}
