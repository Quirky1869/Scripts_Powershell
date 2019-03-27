Get-ADGroup  -Filter "name -like 'G_ordinateurs*'" | foreach {
    $nomgroupe = $_.name
    [string[]]$listemembres = Get-ADGroupMember $nomgroupe | foreach {$_.name}
    if ($listemembres -eq $null) {$nombre = 0} else {$nombre = $listemembres.count}
    "" | select @{n="Groupe";e={$nomgroupe}}, @{n="Nombre";e={$nombre}}
    } 