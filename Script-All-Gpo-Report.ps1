$gpo = (Get-GPO -All).DisplayName


foreach($element in $gpo)
{

Get-GPOReport -Name "$element" -ReportType HTML -Path c:\temp\testgpohtml\$element.html -Verbose

}

<#$gpo2 = (get-gpo -all |? displayName -Match 'Copie de CHA - ADM firefox').Id.Guid

foreach($element2 in $gpo2)
{

Get-GPOReport -Guid "$element2" -ReportType HTML -Path "c:\temp\testgpohtml\Copie de CHA - ADM Firefox-$($element2).html" -Verbose

}#>