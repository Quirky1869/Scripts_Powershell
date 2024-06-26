#requires -version 3.0


#dot source the module files
dir $psScriptRoot\*.ps1 | foreach {
   #write-host $_.fullname -ForegroundColor yellow
 . $_.fullname
}

<#
build a global hashtable of GPO SDK constants. This should be the default
path if you accepted defaults. These functions are not exported from the module
only the variables they create

These functions are not exported.
#>

Function Get-SDMType {

[cmdletbinding()]
Param([string]$assembly="$env:programfiles\windowspowershell\Modules\sdm-grouppolicy\gposdk.dll")

Try {
    Write-Verbose "Loading $assembly"
    #load the assembly and pass results to a variable
    $sdmtype=add-type -path $assembly -passthru -ErrorAction Stop
    Write $sdmtype
}
Catch {
    Write-Warning "Failed to load $assembly"
    Write-Warning $_.Exception.Message
}
} #end Get-SDMType

Function Get-GPSDKEnum {
[cmdletBinding()]
Param(
[Parameter(Position=0,Mandatory=$True)]
[ValidateNotNullorEmpty()]
[object]$sdmType
)
   
#get all the enums
Write-Verbose "Getting enum classes and values"
#including public and private just in case
$sdmenums=$sdmType | where {$_.basetype -match "enum"}

$sdmEnums | Sort Name | foreach -begin {
	  $gposdk=new-object -TypeName PSObject
	} -process {
    $obj=$_
    #get names
    write-Verbose $obj.Name
    
    $h=@{}
    [enum]::GetNames($obj) | foreach {   
        $name=$_
        [int]$Value=$obj::$name
        Write-Verbose ("  {0} = {1}" -f $name,$Value)            
        $h.Add($Name,$Value)
    
   }  #foreach name
   
    #create a custom object
    $gposdk | Add-Member -MemberType Noteproperty -Name $($obj.name) -Value $h 
} #process foreach

#write the result to the pipeline
write $gposdk

Write-Verbose "Finished getting constants and enums"
} #end Get-GPSDKEnum

#get computer and user paths and save them to variables
$gpComputerPath=Get-Content $psScriptRoot\GPComputerPaths.txt
$gpUserPath=Get-Content $psScriptRoot\GPUserPaths.txt

#get SDK Enum variables
$sdmType=Get-SDMType
$gposdk=Get-GPSDKEnum $sdmType 

#functions to export
$myfunctions=@("Get-GPContainer","Get-GPItem","Get-GPSetting",
"Get-GPSettingProperty","Get-GPSettingPropertyType","Get-GPTree",
"Get-GPAEGPO","New-Command","New-GPAdvancedGroupSetting",
"Remove-GPPreferenceSetting","Set-GPComputerScript","Set-GPDeployedPrinter",
"Set-GPDriveMapPreference","Set-GPFolderRedirection","Set-GPSettingProperty",
"Set-GPUserScript","New-GPCommand","New-GPFunction")

Export-ModuleMember -Function $myFunctions -Variable sdmtype,gposdk,gpComputerPath,gpUserPath


$msg=@"
Notes:

Run Get-Command -module SDM-GPAEScript to see all the commands in this module. Be
sure to look at full help and examples.

Run Help gpae to discover about help topics.
"@

Write-Host $msg -ForegroundColor Green

# SIG # Begin signature block
# MIIL7AYJKoZIhvcNAQcCoIIL3TCCC9kCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUyEaPBVmm2nvfRyB0BHoj0oju
# weeggglVMIIEmTCCA4GgAwIBAgIQcaC3NpXdsa/COyuaGO5UyzANBgkqhkiG9w0B
# AQsFADCBqTELMAkGA1UEBhMCVVMxFTATBgNVBAoTDHRoYXd0ZSwgSW5jLjEoMCYG
# A1UECxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNlcyBEaXZpc2lvbjE4MDYGA1UECxMv
# KGMpIDIwMDYgdGhhd3RlLCBJbmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkx
# HzAdBgNVBAMTFnRoYXd0ZSBQcmltYXJ5IFJvb3QgQ0EwHhcNMTMxMjEwMDAwMDAw
# WhcNMjMxMjA5MjM1OTU5WjBMMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMdGhhd3Rl
# LCBJbmMuMSYwJAYDVQQDEx10aGF3dGUgU0hBMjU2IENvZGUgU2lnbmluZyBDQTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJtVAkwXBenQZsP8KK3TwP7v
# 4Ol+1B72qhuRRv31Fu2YB1P6uocbfZ4fASerudJnyrcQJVP0476bkLjtI1xC72Ql
# WOWIIhq+9ceu9b6KsRERkxoiqXRpwXS2aIengzD5ZPGx4zg+9NbB/BL+c1cXNVeK
# 3VCNA/hmzcp2gxPI1w5xHeRjyboX+NG55IjSLCjIISANQbcL4i/CgOaIe1Nsw0Rj
# gX9oR4wrKs9b9IxJYbpphf1rAHgFJmkTMIA4TvFaVcnFUNaqOIlHQ1z+TXOlScWT
# af53lpqv84wOV7oz2Q7GQtMDd8S7Oa2R+fP3llw6ZKbtJ1fB6EDzU/K+KTT+X/kC
# AwEAAaOCARcwggETMC8GCCsGAQUFBwEBBCMwITAfBggrBgEFBQcwAYYTaHR0cDov
# L3QyLnN5bWNiLmNvbTASBgNVHRMBAf8ECDAGAQH/AgEAMDIGA1UdHwQrMCkwJ6Al
# oCOGIWh0dHA6Ly90MS5zeW1jYi5jb20vVGhhd3RlUENBLmNybDAdBgNVHSUEFjAU
# BggrBgEFBQcDAgYIKwYBBQUHAwMwDgYDVR0PAQH/BAQDAgEGMCkGA1UdEQQiMCCk
# HjAcMRowGAYDVQQDExFTeW1hbnRlY1BLSS0xLTU2ODAdBgNVHQ4EFgQUV4abVLi+
# pimK5PbC4hMYiYXN3LcwHwYDVR0jBBgwFoAUe1tFz6/Oy3r9MZIaarbzRutXSFAw
# DQYJKoZIhvcNAQELBQADggEBACQ79degNhPHQ/7wCYdo0ZgxbhLkPx4flntrTB6H
# novFbKOxDHtQktWBnLGPLCm37vmRBbmOQfEs9tBZLZjgueqAAUdAlbg9nQO9ebs1
# tq2cTCf2Z0UQycW8h05Ve9KHu93cMO/G1GzMmTVtHOBg081ojylZS4mWCEbJjvx1
# T8XcCcxOJ4tEzQe8rATgtTOlh5/03XMMkeoSgW/jdfAetZNsRBfVPpfJvQcsVncf
# hd1G6L/eLIGUo/flt6fBN591ylV3TV42KcqF2EVBcld1wHlb+jQQBm1kIEK3Osgf
# HUZkAl/GR77wxDooVNr2Hk+aohlDpG9J+PxeQiAohItHIG4wggS0MIIDnKADAgEC
# AhAj3x/wvlSk7BuUjZq/FfGAMA0GCSqGSIb3DQEBCwUAMEwxCzAJBgNVBAYTAlVT
# MRUwEwYDVQQKEwx0aGF3dGUsIEluYy4xJjAkBgNVBAMTHXRoYXd0ZSBTSEEyNTYg
# Q29kZSBTaWduaW5nIENBMB4XDTE2MTExOTAwMDAwMFoXDTE3MTIxMTIzNTk1OVow
# cjELMAkGA1UEBhMCVVMxEzARBgNVBAgMCkNhbGlmb3JuaWExFDASBgNVBAcMC1Nh
# biBBbnNlbG1vMRswGQYDVQQKDBJTRE0gU29mdHdhcmUsIEluYy4xGzAZBgNVBAMM
# ElNETSBTb2Z0d2FyZSwgSW5jLjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
# ggEBANuVQpDDprX4ErRNOviIv0R4L3UUmWpyXcl1XADXZdfPwZt1pT4+OU5VL84p
# NIKfyYBkXLVLIL7LPm13jqWCnAGqWXMitNrjP02vTKCIJFITzAaJJST+Em42ARsc
# MGPnqf1lajnmH5YXmGkJrVXKeDRinDPiXgVwsNs8rh985+SUl7kTsso9ZTNlLhjw
# 7iijTriVkYbM4H5/a3LEfuvjpsJNPGfW5ZvZHHY7VugjOEHBezGWkUCpLfEb9Nie
# 0pU8Jo8C6wHv6besMx/5QlgNWyxlMKLGqkV2eS4ccLG2IOcQtoUU4q4uVlMvq4vW
# k57+rSBl1lygQ22YPiRG+t5G5HMCAwEAAaOCAWowggFmMAkGA1UdEwQCMAAwHwYD
# VR0jBBgwFoAUV4abVLi+pimK5PbC4hMYiYXN3LcwHQYDVR0OBBYEFLSifz/kWdnM
# ET1bO15BLe0P6oHKMCsGA1UdHwQkMCIwIKAeoByGGmh0dHA6Ly90bC5zeW1jYi5j
# b20vdGwuY3JsMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzBu
# BgNVHSAEZzBlMGMGBmeBDAEEATBZMCYGCCsGAQUFBwIBFhpodHRwczovL3d3dy50
# aGF3dGUuY29tL2NwczAvBggrBgEFBQcCAjAjDCFodHRwczovL3d3dy50aGF3dGUu
# Y29tL3JlcG9zaXRvcnkwVwYIKwYBBQUHAQEESzBJMB8GCCsGAQUFBzABhhNodHRw
# Oi8vdGwuc3ltY2QuY29tMCYGCCsGAQUFBzAChhpodHRwOi8vdGwuc3ltY2IuY29t
# L3RsLmNydDANBgkqhkiG9w0BAQsFAAOCAQEAApQ9oskHgI9yc9ZfCTztDxP3txRK
# SjUQCV2Yi1N8tXQ+NO4bM86EPJ+z/nf4/m1XWpCCk+KUxedovbrXn4c7pWxeoNp+
# eBBe6nHHRw++bxR51ID9TEGKJBooKw6T0DD1IlCHZOwwJANhNnya9TkMwZLQHKXI
# IrKICAkK+IgCHuK+b9gzQUKvW2/GSp8OR4kmKI4oC1vPg3tFhssQW0h0k6gdRmjc
# EA4jbqJTOvC6fCWea0+iU6n7qmNUITtTVi1g0wEo3Z05z/y67aUdrGkeAjLPBvHT
# wAyJC4dvexYtMj/6Ny8lb9ckcFN9JPi9koFlL/VIOT5GN18bw1BOY069OzGCAgEw
# ggH9AgEBMGAwTDELMAkGA1UEBhMCVVMxFTATBgNVBAoTDHRoYXd0ZSwgSW5jLjEm
# MCQGA1UEAxMddGhhd3RlIFNIQTI1NiBDb2RlIFNpZ25pbmcgQ0ECECPfH/C+VKTs
# G5SNmr8V8YAwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAw
# GQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisG
# AQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFBXXyHBoqZMb3efd4pCPvNjEEROsMA0G
# CSqGSIb3DQEBAQUABIIBAEYxGqqyRaeusAp+p+u9c4BvkpZgBIey8HFKgwSKz8th
# jHsNW3DCcY+1y3AeEoLpMZtK4Dh5XHyTexp+pHB/5yxm77O3oO/V0wjsTXsc4qkR
# P4IhJjYbuVVnRZMtUvWX5QW3GPTwdLbYrRMjc/pow/Euv8a/Vn5GlXWNgvcBpCOq
# SwM7123cgVx/gSg/4DJfAFSOG3oXWkdS0yYrad0cjhYjLliq4uQkVZ0+ma8K4ldb
# XP/Z3SKGyRPqAZDnVEgo6+/HQK4/ijQGSBQHKsPAQ97kOFbscuSC0LiHVPT1ZfWF
# W8YXyaQ19GNwgvJvWSWGeVLhu0qgv85JERztGgJj4Qs=
# SIG # End signature block
