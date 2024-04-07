Get-ADGroup  -Filter "name -like 'G_ordinateurs*'" | foreach { 

    $nomgroupe = $_.name 

    $Destination = (Get-ChildItem Env:\USERPROFILE).value + "\Groupe.CSV"

    Write-Host "Export de : $($_.name) avec $($listemembres.count) "

    <#[string[]]#>$listemembres = Get-ADGroupMember $nomgroupe | foreach {$_.name}

    if ($listemembres -eq $null) {$nombre = 0} else {$nombre = $listemembres.count} ""| 

     select @{n="Groupe";e={$nomgroupe}}, @{n="Nombre";e={$nombre}} 



    } | <#out-file#> Export-Csv <#-filepath#> -Path $Destination 

        Invoke-Item -Path $Destination