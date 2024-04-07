$event = get-eventlog -LogName Application -newest 1
#get-help get-eventlog will show there are a handful of other options available for selecting the log entry you want.
#example: -source "your-source"
 
# "Error" - send only error
if ($event.EntryType -eq "Error")
{
    $PCName = $env:COMPUTERNAME
    $EmailBody = $event | format-list -property * | out-string
    $EmailFrom = "$PCName jacotet.michael@ch-avignon.fr"
    $EmailTo = "jacotet.michael@ch-avignon.fr" 
    $EmailSubject = "New Event Log [Application]"
    $SMTPServer = "owa.ch-avignon.fr"
    Write-host "Sending Email"
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -body $EmailBody -SmtpServer $SMTPServer
}
else
{
    write-host "No error found"
    write-host "Here is the log entry that was inspected:"
    $event
}