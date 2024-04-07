#################################################################Script God Mode#################################################################
$destination = (Get-ChildItem Env:\USERPROFILE).value + '\Desktop'

New-Item -ItemType directory -Path $destination -Name  'GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}'