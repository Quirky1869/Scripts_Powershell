#Requires -version 2.0

Function Get-GPSettingPropertyType {
<#
.Synopsis
Discover setting property names and type
.Description
This command takes a GPO Setting and returns information that shows property
names and their type.
.Parameter Settings
A GPOSDK Settings object
.Parameter AsHashTable
Write results to the pipeline as a hash table.
.Example
PS C:\> $system = get-gpcontainer -Path "user configuration\administrative templates\system" -gpo $gpo
PS C:\> Get-GPSetting -container $system -Name "prevent access to the command prompt" | get-GPSettingPropertyType | format-list

Property : State
Type     : System.Int32

Property : Disable the command prompt script processing also?
Type     : System.Int32
.Example
PS C:\> $prophash=$gpo | Get-GPContainer -Path "Computer Configuration/Administrative Templates/Windows Components/Windows Remote Shell" | Get-GPSetting -name "MaxConcurrentUsers" | Get-GPSettingPropertyType -AsHashTable
PS C:\> $prophash

Name                           Value
----                           -----
MaxConcurrentUsers             System.Int32
State                          System.Int32
.Link
Get-GPSetting
Get-GPSettingProperty
#>

[cmdletbinding()]

Param(
[Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True,
ValueFromPipelineByPropertyName=$True,ParameterSetName="Object")]
[ValidateNotNullorEmpty()]
[GPOSDK.IGPSetting[]]$Settings,
[switch]$AsHashTable
)

Begin {
    Write-Verbose "Starting $($myinvocation.mycommand)"
    #define all the read-only property names
    $readonly="_ITEMS|_MIN|_MAX|_MAXLEN|_DEFAULT|CONTROLTYPE|VALUENAME|KEYNAME|FRIENDLYNAME|VALUEON|VALUEOFF|PROPERTYNAMES|FRIENDLYNAME|Description|Requirements"
}
Process {
    foreach ($setting in $settings) {
        Write-Verbose "Getting property names from $($setting.gpspath)"
        $PropertyNames=$setting.GetPropertyNames() | 
        where {$_ -notmatch $readonly}
        
        #hash table for values
        $hash=@{}
        #array for custom objects
        $data=@()
        foreach ($property in $propertynames) {
            Write-Verbose $property
            Try {
                $type=$setting.Get($property).GetType().FullName
            }
            Catch {
                $type="Unknown"
            }
            $hash.Add($Property,$Type)
            $data+=New-object -TypeName PSObject -Property @{
                Property=$Property
                Type=$Type
            }
        } #foreach property
        if ($AsHashTable) {
            $hash
        }
        else {
            $data
        }
    } #foreach setting
} #process
End  {
    Write-Verbose "Ending $($myinvocation.mycommand)"
}

} #end Get-GPSettingPropertyType
