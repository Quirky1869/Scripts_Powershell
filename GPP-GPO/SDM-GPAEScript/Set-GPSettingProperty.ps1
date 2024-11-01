#requires -version 2.0

Function Set-GPSettingProperty {

<#
.Synopsis
Get the property values for a group object setting
.Description
The command will update the property values of a group policy setting object.
You can apply new settings by either passing a hash table of of property names and 
values or by passing a custom object with the corresponding property names and values.

NOTE: PROPERTY NAMES ARE CASE SENSITIVE AND MOST LIKELY WILL NEED TO BE QUOTED TO
HANDLE SPACES AND SPECIAL CHARACTERS.

This command will not write anything to the pipeline unless you use -Passthru.
.Parameter Setting
A GPO SDK Settings object
.Parameter PropertyTable
A hash table of new property values.
.Parameter PropertyObject
An object with new property values. The property names must match that of the
setting. 
.Parameter Passthru
Write the new setting to the pipeline
.Example
PS C:\> $setting | set-GPSettingProperty -PropertyTable @{"Seconds:"=900}

Modifying a single setting using a hash table. Notice the setting name has a colon
(:) so the key is enclosed in quotes.
.Example
PS C:\> $current=$setting | Get-GPSettingProperty
PS C:\> $current."Seconds:"
900
PS C:\> $current."Seconds:"=450
PS C:\> $setting | Set-GPSettingProperty -PropertyObject $current -Passthru | Get-GPSettingProperty
           State Seconds:
           ----- --------
               1 450

Get the current setting and save as an object. Modify the "Seconds:" property and 
apply the object as the source for the new settings. The last example writes the
new setting to the pipeline and retrieves the value. Note that you might get errors
for read-only settings, which is ok.
.Example
PS C:\> $desk=$gpo | get-gpcontainer "user configuration\administrative templates\Desktop"
PS C:\> $r=$desk | get-gpsetting | where {$_.name -match "^remove recycle"}
PS C:\> $r | Set-GPSettingProperty -PropertyTable @{State=$gposdk.AdmTempSettingState.Enabled}

The first command gets the Desktop adminstrative template setting container.
The second line saves the setting that starts with "Remove Recycle". This returns
the setting for Remove Recycle Bin icon from desktop. The last line sets a new
value for the state using the $gposdk variable.

PS C:\> $gposdk.AdmTempSettingState

Name                           Value
----                           -----
Undefined                      -1
Disabled                       0
Enabled                        1

You can use the variable name or the value.
PS C:\> $r | Set-GPSettingProperty -PropertyTable @{State=0}

.Link
Get-GPContainer
Get-GPSetting
Get-GPSettingProperty
Get-GPSettingPropertyType
#>

[cmdletbinding(SupportsShouldProcess=$True,DefaultParameterSetName="hash")]

Param(
[Parameter(Position=1,ValueFromPipeline=$True,Mandatory=$True)]
[ValidateNotNullorEmpty()]
[GPOSDK.IGPSetting]$Setting,
[Parameter(Position=0,ParameterSetName="Hash",HelpMessage="Enter a hash table of new property values")]
[ValidateNotNullorEmpty()]
[hashtable]$PropertyTable,
[Parameter(Position=0,ParameterSetName="Object",HelpMessage="What is the property object?")]
[ValidateNotNullorEmpty()]
[object]$PropertyObject,
[switch]$Passthru
)

Begin {
    Write-Verbose "Starting $($myinvocation.mycommand)"
}

Process {
    Write-Verbose "Processing setting for $($setting.name)"
    
    if ($PropertyTable) {
    	Write-Verbose "Processing a property hash table"
	    Foreach ($key in $PropertyTable.Keys) {
	        Write-Verbose "Setting $key"
	        if ($pscmdlet.ShouldProcess($key)) {
	            $value=$PropertyTable.item($key)
	            if ($value -is [array]) {
	                $Setting.PutEx([GPOSDK.PROPOP]::PROPERTY_UPDATE,$Key,$value)
	            }
	            else {
	                $Setting.Put($key,$Value)
	            }
	        } #should process
	        
	    } #foreach
    }
    else {
    	Write-Verbose "Processing a property object"
    	
    	#get property names from property object
    	$properties=$PropertyObject | 
    	 Get-Member -MemberType *Properties | 
    	 Select-Object -expandproperty Name
    	
    	foreach ($property in $properties) {
    	   Write-Verbose "Setting $property"
    	  #get the value
	      $value=$PropertyObject."$Property"
	      Write-Verbose ($value | out-string)
	      
	      if ($pscmdlet.ShouldProcess($property )) {
	      #test if value is an array or not so we know whether to use Put() or PutEx()
	      if ($value -is [array]) {
	        Write-Verbose "$Property is an ARRAY"
	        $Setting.putex([GPOSDK.PROPOP]::PROPERTY_UPDATE,$property,$value) 
	      }
	      else {
	        $Setting.put($property,$value) 
	      }
    	 } #should process
    	} #foreach $property   	
	    
    } #else
    
    if ($pscmdlet.shouldprocess("Setting $($setting.name)")) {
        Write-Verbose "Saving new settings"
        $setting.save()
        
        #write the setting object to the pipeline
        if ($passthru) {
            Write $Setting
        }
    } #should process
} #process


End {
    Write-Verbose "Ending $($myinvocation.mycommand)"
}

} #Set-GPSettingProperty
