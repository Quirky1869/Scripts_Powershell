# Dane Kantner 3/11/2013
# Lists/enumerates all printers shared on print server, then cross-matches them against installed drivers for driver info.
# To use, populate $Servers list below with your server names. For one server, specify $Servers=("Server1")
cls
$Servers=("PrintServ","PrintServ2")
#Directory where this file will save
$excelfilename= "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Excel 2010.lnk" #"\\contoso.com\public\dk\ListPrintServers\"   

$PrintIPColumn="K" # location of "log" hyperlink column

#day-hour-minute will append
if (-not (test-path $excelfilename)) {
	mkdir $excelfilename
}

$dateparts = Get-Date
$excelfilename=$excelfilename + $dateparts.Year + "-" + ("{0:d2}" -f $dateparts.Month) + "-" + ("{0:d2}" -f $dateparts.Day) + "-" + ("{0:d2}" -f $dateparts.Hour) + "-" + ("{0:d2}" -f $dateparts.Minute)
$TempLocation="c:\tempPRSRVreport"
Write-Host "File will save as $excelfilename"
$Skip32Dups=$true
if ($Skip32Dups) {
	Write-Host "If 64 and 32 bit drivers are both installed, skipping explicit listing of 32 item."
}

# create the excel application
$script:excel = New-Object -comobject Excel.Application
# disable excel alerting (For overwrite of file
$script:excel.DisplayAlerts = $False
$script:excel.Visible = $true
$script:workbook = $script:excel.Workbooks.Add()

##$DelSheet=$script:workbook.sheets.item(2)
##$DelSheet.delete() 
##$DelSheet=$script:workbook.sheets.item(2)
##$DelSheet.delete() 
	
 #Column Headings for DS Sheet

	
#define Numbers - start all at second row
$Script:hcol = [Int64]1
$Script:hrow = [Int64]2




$i=0
foreach ($Printserver in $Servers) {
	$Drive="C"
	Write-Host "checking $Printserver now"
	
	if ($i -gt 0) {
		#add a worksheet
		$script:workbook.sheets.add() | Out-Null
		$i++
	} else {
	#first run, inc anyway so its now 1
		$i++
	}
	#could active 1 or i. first or i
	$script:servicesheet = $script:workbook.sheets.Item(1)
	$script:servicesheet.activate()
	$headings = @("SystemName","sharename","drivername","comment","name","attributes","jobcountsincelastreset","location","papersizessupported","portname","IP Address","error state","errordescription","printer status","printerstatus")
	$Script:hrow = 1
	$Script:hcol = 1
	$Script:hcoltmp = 0
	$script:servicesheet.Name = $Printserver
	$headings | % { 
  	 	 $script:servicesheet.cells.item($Script:hrow,$Script:hcol)=$_
  	 	 $Script:hcol=1+$Script:hcol
	}

	$cdx=2
	
	$AllSharedPrinters = @(Get-WmiObject win32_printer -ComputerName $Printserver -Filter 'shared=true') 
	$Drivers = get-wmiobject -class "Win32_PrinterDriver" -computer $Printserver
	#$allprinters[0].drivername
	foreach ($SharedPrinter in $AllSharedPrinters) {
		$search='*' + $SharedPrinter.drivername +'*'
		$results=@($Drivers | Where-Object {$_.name -like "$search"})
		#determine if two needed
		
	
		
		foreach ($driverfile in $results) {
	
			
			$MyDriverPath=$driverfile.DriverPath.Replace("$Drive`:","\\$PrintServer\$Drive`$")
		
			if (($results.count -gt 1) -and ($MyDriverPath -match 'W32') -and ($Skip32Dups)) {
			#Write-Host "Skipping 32 bit listing $MyDriverPath"
			#both 32 bit and 64 bit driver installed, we only care to list 64
			continue;
			}
			$DriverVersion=""
			$DriverDate=""
			$MyDriverDataPath=""
			$DriverDataVersion=""
			$DriverDataDate=""
			$DriverConfigDate=""
			$DriverConfigVersion=""
			$MyDriverConfig=""
			
			$MyDriver=(Get-ItemProperty ($MyDriverPath))
			$DriverVersion = $MyDriver.VersionInfo.ProductVersion
			$DriverDate=$MyDriver.LastWriteTime
			
			$MyDriverDataPath=$driverfile.datafile.Replace("$Drive`:","\\$PrintServer\$Drive`$")
			$MyDriverData=(Get-ItemProperty ($MyDriverDataPath))
			$DriverDataVersion = $MyDriverData.VersionInfo.ProductVersion
			$DriverDataDate=$MyDriverData.LastWriteTime
			
			
			$MyDriverConfigPath=$driverfile.configfile.Replace("$Drive`:","\\$PrintServer\$Drive`$")
			$MyDriverConfig=(Get-ItemProperty ($MyDriverConfigPath))
			$DriverConfigVersion = $MyDriverConfig.VersionInfo.ProductVersion
			$DriverConfigDate=$MyDriverConfig.LastWriteTime
			
			$col=1
			$script:servicesheet.Cells.Item($Script:cdx,$col) = "$($SharedPrinter.SystemName)"
				$col=1+$col
				$script:servicesheet.Cells.Item($Script:cdx,$col) = "$($SharedPrinter.sharename)"
				$col=1+$col
				$script:servicesheet.Cells.Item($Script:cdx,$col) = "$($SharedPrinter.drivername)"
				$col=1+$col
				$script:servicesheet.Cells.Item($Script:cdx,$col) = "$($SharedPrinter.comment)"
				$col=1+$col
				$script:servicesheet.Cells.Item($Script:cdx,$col) ="$($SharedPrinter.name)"
				$col=1+$col
				$script:servicesheet.Cells.Item($Script:cdx,$col) ="$($SharedPrinter.attributes)"
				$col=1+$col
				
				$script:servicesheet.Cells.Item($Script:cdx,$col) ="$($SharedPrinter.jobcountsincelastreset)"
				$col=1+$col
				$script:servicesheet.Cells.Item($Script:cdx,$col) ="$($SharedPrinter.location)"
				$col=1+$col
				$script:servicesheet.Cells.Item($Script:cdx,$col) ="$($SharedPrinter.papersizessupported)"
				$col=1+$col
				$script:servicesheet.Cells.Item($Script:cdx,$col) ="$($SharedPrinter.portname)"
				$col=1+$col
				
				$IPAddress=""
				If (($($SharedPrinter.portname).length) -gt 1) { 
				 	$Printerports = @(Get-WmiObject Win32_TcpIpPrinterPort -Filter "name = '$($SharedPrinter.Portname)'" -ComputerName $Printserver)
					ForEach ($item in $Printerports)
                	{
				      $IPAddress += $item.HostAddress
						  if ($Printerports.count -gt 1) {
						  	$IPAddress += " "
						  }
                	}
					$script:servicesheet.Cells.Item($Script:cdx,$col) =$IPAddress
					if (($Printerports.count) -eq 1) {
							$IPAddressLink="http://" + $IPAddress + "/"
							#Write-Host "Attempting to add link $IPAddressLink"
						  	$myr = $script:servicesheet.Range([string]$PrintIPColumn+[string]$Script:cdx+":" + [string]$PrintIPColumn +[string]$Script:cdx)
							$objLink = $script:servicesheet.Hyperlinks.Add($myr,$IPAddressLink) 
							while( [System.Runtime.Interopservices.Marshal]::ReleaseComObject($myr)){ }
							while( [System.Runtime.Interopservices.Marshal]::ReleaseComObject($objLink)){ }
					} else {
					#Write-Host "not attempting to add link ; count is $($Printerports.count)"
					} 
            	} #end if portname is filled in on share
       			$col=1+$col
				
				$script:servicesheet.Cells.Item($Script:cdx,$col) ="$($SharedPrinter.errordescription)"
				$col=1+$col
				
				$script:servicesheet.Cells.Item($Script:cdx,$col) ="$($SharedPrinter.ExtendedDetectedErrorState)"
				$col=1+$col
				
				
				$extendedprintstatuses= @("-","Other","Unknown","Idle","Printing","Warming Up","Stopped Printing","Offline","Paused","Error","Busy","Not Available","Waiting","Processing","Initialization","Power Save","Pending Deletion","IO Active","Manual Feed")
				$script:servicesheet.Cells.Item($Script:cdx,$col) =$extendedprintstatuses[$($SharedPrinter.extendedprinterstatus)]
				$col=1+$col
				
				$printstatuses= @("","Other","Unknown","Idle","Printing","Warming Up","Stopped printing","Offline")
				
				$script:servicesheet.Cells.Item($Script:cdx,$col) = $printstatuses[$($SharedPrinter.printerstatus)]
				$col=1+$col
				
				$cdx=1+$cdx
		} #end foreach driver file
		$script:servicesheet.Rows.AutoFit() | Out-Null
		$script:servicesheet.Columns.AutoFit() | Out-Null
	} #end foreach shared printer
} #end foreach print server itself

$workbook.SaveAs($excelfilename)
$workbook.Close
