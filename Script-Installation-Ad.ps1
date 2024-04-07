# Installation du rôle AD DS (Active Directory)

Install-WindowsFeature -Name ad-domain-services -IncludeManagementTools -Verbose

# Installation de la fôret

Install-ADDSForest -DomainName test.local #-InstallDNS

# Import du module ActiveDirectory

Get-module -ListAvailable
Start-Sleep -Seconds 1
Import-Module ActiveDirectory
Get-Module

# Création des variables pour la création d'un utilisateur

$prenom = Read-Host "Prenom"
$nom = Read-Host "Nom"
$description = Read-Host "Description"
$prenomnom = $prenom + $nom
$currentUser = [Environment]::UserName

# Créer un utilisateur ActiveDirectory

New-ADUser -Name "$($prenom) $($nom)" -GivenName $prenom -Surname $nom `
  -SamAccountName $prenomnom -UserPrincipalName $prenomnom@test.local `
  -Description "$($description)" `
  -Credential test.local\$currentUser `
  -AccountPassword (Read-Host -AsSecureString "Mettez ici votre mot de passe :") `
  -PassThru | Enable-ADAccount

# Création d'un Groupe ActiveDirectory "Production"

New-ADGroup -Name "Production" -GroupScope Global

# Ajout d'un Utilisateur "Paul Hewitt" dans le groupe "Production"

Add-ADGroupMember -Identity "Production" -Member "PaulHewitt"

# Activer et désactiver un compte utilisateur "Paul Hewitt"

Enable-ADAccount -Identity PaulHewitt
Disable-ADAccount -Identity PaulHewitt

# Désactiver tous les comptes d’un groupe "Production"

Get-ADGroupMember "Production" | Disable-ADAccount

# Déverrouiller un compte d'utilisateur "Paul Hewitt"

Unlock-ADAccount PaulHewitt

# Lister tous les comptes ActiveDirectory

Get-ADUser -Filter * | Format-List

# Supprimer un compte utilisateur "Paul Hewitt"

Remove-ADUser PaulHewitt