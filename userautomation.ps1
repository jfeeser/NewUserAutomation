$userFN = Read-Host -Prompt "First Name"
$userLN = Read-Host -Prompt "Last Name"
$fullName = "$userFN $userLN"
$emailAddress = "$userFN.$userLN@mckinc.com"
$samAccountName = "$userFN.$userLN"
$officeCode = Read-Host -Prompt "Enter Office Code"

if ($officeCode -eq "DC") {
    $pathOU = 'OU=MCK DC,OU=MCK Users,DC=ad,DC=mckissackdc,DC=com'
}
elseif ($officeCode -eq "CHI") {
    $pathOU = "OU=MCK Chicago,OU=MCK Users,DC=ad,DC=mckissackdc,DC=com"
}
elseif ($officeCode -eq "LA") {
    $pathOU = "OU=MCK LA,OU=MCK Users,DC=ad,DC=mckissackdc,DC=com"
}
elseif ($officeCode -eq "BAL") {
    $pathOU = "OU=MCK Baltimore Users,OU=MCK Users,DC=ad,DC=mckissackdc,DC=com"
}
else{
    Write-Host "Invalid Office Code!"
    exit
}

##variable output testing
#$fullName
#$emailAddress
#$samAccountName
#$pathOU

New-ADUser -name "$fullName" -EmailAddress "$emailAddress" -Path "$pathOU" -GivenName "$userFN" -Surname "$userLN" -SamAccountName "$samAccountName" -UserPrincipalName "$emailAddress" -AccountPassword (Read-Host -AsSecureString "AccountPassword") -PassThru |Enable-ADAccount

$cloneUser = Read-Host -prompt "User to clone permissions from (SAMAccountName): "

Get-ADUser -Identity $cloneUser -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members "$samAccountName"

Write-Host "User Created!"
