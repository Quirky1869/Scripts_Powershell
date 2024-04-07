$GroupSID = (Get-ADGroup -filter "name -like 'G_Ordinateurs_Algeco_COVID19'").Sid.Value

$Inputlist = @([pscustomobject]@{Name="TEST";UserContext="1";Path="\\Printserv2\TEST";GroupName="G_Ordinateurs_Algeco_COVID19";GroupSID="$GroupSID";Action="U";GPOName="CHA Mappe Printers"})
#$Inputlist = import-csv $InputFilePath
$GPOName = $inputlist.GPOName | Select-Object -Unique

$FDRDatum = (Get-Date).tostring("yyyyMMdd")

$GPOBackupFDR = "C:\temp\$FDRDatum"

If(!(test-path $GPOBackupFDR))

    {
      New-Item -ItemType Directory -Path $GPOBackupFDR
    }

If (($GPOName).Count -eq 1)

    {
        $GPOID = Get-GPO $GPOName | Select-Object ID
        Backup-GPO $GPOName -path $GPOBAckupFDR

        $GPP_PRT_XMLPath =  "\\dc1\SYSVOL\adcha.local\Policies\{5825F5D0-D79B-4278-99AC-B643E7FA23A2}\User\Preferences\Printers\Printers-backup.xml"
        [XML]$PRNT = (Get-Content -Path $GPP_PRT_XMLPath)

            foreach ($e in  $Inputlist)

                {
                 $CurrentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                 $newguid = [System.Guid]::NewGuid().toString()
                 $NewEntry = $PRNT.Printers.SharedPrinter[0].Clone()
                 $NewEntry.Name = $e.Name
                 $NewEntry.Status = $e.Name
                 $NewEntry.Changed = "$CurrentDateTime"
                 $NewEntry.uid = "{" + "$newguid" + "}"
                 #$NewEntry.userContext = $e.UserContext
                 $NewEntry.properties.path = $e.Path
                 $NewEntry.properties.action = $e.action
                 $NewEntry.filters.Filtergroup.Name = $e.GroupName
                 $NewEntry.filters.Filtergroup.SID = $e.GroupSID
                 $PRNT.DocumentElement.AppendChild($NewEntry)
                    }

            $PRNT.Save($GPP_PRT_XMLPath)
    }

Else {Write-Host -ForegroundColor Red "ERROR: GPOName not unique"}