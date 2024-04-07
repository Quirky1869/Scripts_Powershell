Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::YesNo
$MessageIcon = [System.Windows.MessageBoxImage]::Asterisk
$MessageBody = "Are you sure you want to delete the log file?"
$MessageTitle = "Confirm Deletion"

$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

Write-Host "Your choice is $Result"