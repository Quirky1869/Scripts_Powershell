function Get-ADPrincipalGroupMembershipRecursive( ) {

    Param(
        [string] $dsn,
        [array]$groups = @()
    )

    $obj = Get-ADObject $dsn -Properties memberOf

    foreach( $groupDsn in $obj.memberOf ) {

        $tmpGrp = Get-ADObject $groupDsn -Properties memberOf

        if( ($groups | where { $_.DistinguishedName -eq $groupDsn }).Count -eq 0 ) {
            $groups +=  $tmpGrp           
            $groups = Get-ADPrincipalGroupMembershipRecursive $groupDsn $groups
        }
    }

    return $groups
}

# Simple Example of how to use the function
$username = Read-Host -Prompt "Enter a username"
$groups   = Get-ADPrincipalGroupMembershipRecursive (Get-ADUser $username).DistinguishedName
$groups | Sort-Object -Property name | Format-Table