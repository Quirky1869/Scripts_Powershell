#requires -version 2.0

Function Get-GPTree {

<#
.Synopsis
Get a GPO container tree-view 
.Description
Enumerate all containers in a GPO object displaying them in a tree format.
Or use -PathOnly to only get full paths.
.Parameter Containers
A GPOSDK containers object. Or you can pipe GPO object created from Get-SDMGpo.
.Parameter Tab
Used to display the Tree. You shouldn't need to modify this.
.Parameter PathOnly
Display the full path of each container
.Example
PS C:\> Get-GPContainer -path "User Configuration" -gpo $gpo | Get-GPTree
.Example
PS C:\> $userconfig=get-gpcontainer -Path "user configuration" -gpo "MyTestGPO"
PS C:\> $userconfig | get-gptree -pathonly | out-file UserConfigPaths.txt
.Link
Get-GPContainer
#>

[cmdletbinding(DefaultParameterSetName="Tree")]

Param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Specify a GPO object with containers",
ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
[ValidateNotNullorEmpty()]
[GPOSDK.GpContainerImpl[]]$Containers,
[Parameter(ParameterSetName="Tree")]
[int]$Tab=0,
[Parameter(ParameterSetName="Path")]
[switch]$PathOnly
)

Process {

    foreach ($container in $containers) {
        if ($pathOnly) {
          #strip off leading \ and change \ to /
          $container.GPSPath.Substring(1).Replace("\","/")
          $container.Containers | Get-GPTree -PathOnly
        }
        Else {
        
        if ($tab -eq 0) {
           $lead=""
        }
       
        else {
         $lead="$(' '*$Tab)"
        }

        $leaf="{0}{1}" -f $lead,$Container.Name
        Write $leaf
        
        $container.containers | foreach {
          Get-GPTree -Container $_ -tab $Tab
          $tab++
        }
        
        }
    } #foreach

} #process

}