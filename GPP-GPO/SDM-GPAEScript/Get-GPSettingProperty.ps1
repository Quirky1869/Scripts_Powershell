#requires -version 2.0

Function Get-GPSettingProperty {

<#
.Synopsis
Get the property values for a group policy object setting
.Description
This command will enumerate the properties and values of a group policy settings object.
By default it will only display properties that you can modify. To see all properties,
use the -All parameter. 

The command will write a custom object to the pipeline, or you can use -AsHashtable
which will return all properties and values in a hash table.
.Parameter Settings
A GPOSDK Settings object
.Parameter GPO
A GPO object created with the Get-SDMGpo cmdlet.
.Parameter GPSPath
The path to a GPO setting. This has an alias of Path
.Parameter All
Display all parameters
.Parameter AsHashTable
Write property results as a hash table.
.Example
PS C:\> $setting = get-gpcontainer -Path "User Configuration/Administrative Templates/Control Panel/Personalization" -gpo $gpo | get-gpsetting  -name "Screen saver timeout" 
PS C:\> $setting | Get-GPSettingProperty

  State Seconds:
  ----- --------
      1 600
                           
PS C:\> $setting | Get-GPSettingProperty -all

Seconds:_MAX         : 599940
State                : 1
KEYNAME              : Software\Policies\Microsoft\Windows\Control Panel\Desktop
Parent               : GPOSDK.GPContainerImpl
Seconds:             : 600
Seconds:_VALUENAME   : ScreenSaveTimeOut
FriendlyName         : Screen saver timeout
Seconds:_CONTROLTYPE : 6
.Example
PS C:\> $setting | Get-GPSettingProperty -ashash

Name                           Value
----                           -----
State                          1
Seconds:                       600

.Link
Get-GPContainer
Get-GPSettingPropertyType
Set-GPSettingProperty
#>

[cmdletbinding(DefaultParameterSetName="Object")]

Param(
[Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True,
ValueFromPipelineByPropertyName=$True,ParameterSetName="Object")]
[ValidateNotNullorEmpty()]
[GPOSDK.IGPSetting[]]$Settings,

[Parameter(Position=0,Mandatory=$True,
ValueFromPipelinebyPropertyName=$False,
ParameterSetName="Path")]
[ValidateNotNullorEmpty()]
[Alias("path")]
[string]$GPsPath,

[Parameter(Position=1,Mandatory=$True,
HelpMessage="What is the GPO object?",
ValueFromPipeline=$True,
ParameterSetName="Path")]
[GPOSDK.IGPObject]$GPO,
[switch]$All,
[switch]$AsHashtable
)

Begin {
    Write-Verbose "Starting $($myinvocation.mycommand)"
    Write-verbose "Using parameter set $($pscmdlet.ParameterSetname)"
    
    #define all the read-only property names
    $readonly="_ITEMS|_MIN|_MAX|_MAXLEN|_DEFAULT|CONTROLTYPE|VALUENAME|KEYNAME|FRIENDLYNAME|VALUEON|VALUEOFF|PROPERTYNAMES|FRIENDLYNAME|Description|Requirements"
  }

Process {
Write-Verbose "Processing each setting"
 If ($pscmdlet.ParameterSetName -eq "Path") {
      Write-Verbose "Validating path"
      #get by name or path
      #fix and validate path
      $GPsPath=$GPsPath.Replace("\","/")
      if ($GPsPath.StartsWith("/")) {
        $GPsPath=$GPsPath.Substring(1)
      }
      Write-verbose "Getting $GPsPath"
      $settings=$gpo.GetObject($GPsPath).Settings
    } #if path
    else {
    	Write-Verbose "Getting settings from Settings object"
    }
     
     foreach ($setting in $settings) {
     Write-Verbose "Getting properties from $($setting.name)"
      #filter out properties with an _ unless -All
        if ($All) {
        	Write-Verbose "Getting all properties"
            #filter out those instances where there is a blank property
        	$PropertyNames=$setting.GetPropertyNames() | where {$_}
        }
        else {
        	$PropertyNames=$setting.GetPropertyNames() | where {$_ -AND $_ -notmatch $readonly}
        }
        
        $PropertyNames | 
         foreach -begin {
          $h=@{} } -process {
           Write-verbose "Adding $_"
           
           <#
           ????
            test and see if setting is an array. If so use GetEx()
            otherwise use Get()
           #>           
           
           $h.Add($_,$setting.Get($_)) 
           } -end {
           	  if ($All) {
           	  	#add the parent object to the hash table
                Write-Verbose "Adding parent setting"
           	  	$h.add("Parent",$setting.Parent)
           	  }
              if ($AsHashtable) {
                #write the settings out as a hash table
                Write-Verbose "Creating raw hash table"
                $h
              }
              else {
                #create a custom object
                New-Object -TypeName PSObject -Property $h 
               }
           } #end
         } #foreach  
    } #process  
    
End {
     Write-Verbose "Ending $($myinvocation.mycommand)"
}
} #Get-GPSettingProperty
