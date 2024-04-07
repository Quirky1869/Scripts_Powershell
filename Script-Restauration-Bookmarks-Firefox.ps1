# Copie bookmarks Firefox #

$pathBookmarks = Get-ChildItem "U:\CDucellier\Firefox\0 - Template\bookmarkbackups" | `
Select-Object Name, LastWriteTime  <#| where {$_ -match "2019"}#> | Sort-Object -Descending -Property "LastWriteTime" | Select-Object -First 1

Write-Host $pathBookmarks

#Copy-Item -Path $a -Destination "b:\"

$pathBookmarks