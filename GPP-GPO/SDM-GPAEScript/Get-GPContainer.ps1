#requires -version 2.0

Function Get-GPContainer {
<#
.Synopsis
Get a GPO container
.Description
This command will return a container object from a GPO such as User or
Computer. Pipe a GPO object to this cmdlet.
.Parameter Container
A GPOSDK container object. Or you can pipe GPO object created from Get-SDMGpo.
.Parameter Path
The path to a GPO container
.Parameter GPO
A GPO object created with the Get-SDMGpo cmdlet or the name of a GPO.
.Parameter Recurse
Get all containers recursively from the starting container.
.Example
PS C:\> get-gpcontainer -path "user configuration\Preferences" -gpo $gpo
.Example
PS C:\> "user configuration\administrative templates\system" | get-gpcontainer -gpo "MyTestGPO"
.Example
PS C:\> $admintemp=Get-GPContainer -Path "user configuration\administrative templates" -gpo $gpo
PS C:\> $admintemp

Name           : Administrative Templates
Parent         : GPOSDK.GPContainerImpl
GPObject       : GPOSDK.GPObjectImpl
GPsPath        : \User Configuration\Administrative Templates
Containers     : {System, Windows Components, Network, Shared Folders...}
Settings       : {}
Provider       : GPOSDK.Providers.AdmTProvider
GPO            : GPOSDK.GPObjectImpl
ExtensionGUIDs : [{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{0F6B957E-509E-11D1-A7CC-0000F87571E3}]

PS C:\> $adminTemp | get-gpcontainer -recurse | Select Name

Name
----
Administrative Templates
System
Ctrl+Alt+Del Options
Driver Installation
Folder Redirection
...

.Link
Get-GPTree
Get-SDMGpo

#>

[cmdletbinding(DefaultParameterSetName="Path")]

Param(
[Parameter(Position=0,Mandatory=$True,
ValueFromPipeline=$True,
ValueFromPipelineByPropertyName=$True,
ParameterSetName="Object")]
[GPOSDK.GPContainerImpl]$Container,

[Parameter(Position=0,Mandatory=$True,
ValueFromPipeline=$True,
ValueFromPipelineByPropertyName=$True,ParameterSetName="Path")]
[ValidateNotNullorEmpty()]
[string]$Path,

[Parameter(Position=1,Mandatory=$True,
HelpMessage="Enter a GPO Object reference",
ParameterSetName="Path")]
[Object]$GPO,

[Switch]$Recurse

)

Process {
    #if $GPO is a string get the GPO object
    if ($gpo -is [string]) {
        Write-Verbose "Retrieving GPO object for $gpo"
        $gpo=Get-SDMGPO -Displayname $gpo
    }

    if ($pscmdlet.ParameterSetName -eq "Object") {
      Write-Verbose "Getting containers from $($container.name)"
      $myContainer=$container
      #$myContainer
     
    } #if container
    
    else {
        write-verbose "Getting path $path"
        if ($Path) {
            #remove leading slash
            if ($path.startswith("\")) {
                $path=$Path.Substring(1)
            }
            #switch slashes around if necessary
            if ($path -match "\\") {
                $path=$path.Replace("\","/")
            }
            
             if ($path -notmatch "/") {
                 <#
                 add a trailing slash if there are no slashes
                 This will prevent errors if the path is like
                 User Configuration
                 #>
                $path+="/"
             }
             
            $myContainer=$gpo.GetObject($path)
            
        } #if $path
    } #else path
   
   $mycontainer 
   
    if ($Recurse) {
        $mycontainer | Select -ExpandProperty Containers | Get-GPContainer -recurse
      }
   
} #process
} #end Get-GPContainer
