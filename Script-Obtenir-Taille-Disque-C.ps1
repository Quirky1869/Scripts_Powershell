$drive = Get-WmiObject -class Win32_LogicalDisk | where-object {$_.DeviceID -eq "C:"}
$freeGB = ($drive.FreeSpace/1024/1024/1024)
$freeGB = [math]::Round($freeGB,2)
"C:\ = " +$freeGB + " GB"