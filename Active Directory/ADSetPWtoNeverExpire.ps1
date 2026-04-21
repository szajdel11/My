Import-Module ActiveDirectory

Get-ADUser -SearchBase "OU=Associate Staff,OU=HEH-Users,DC=hehs,DC=internal" -Filter * |
Set-ADUser -PasswordNeverExpires $true

Get-ADUser -SearchBase "OU=Students,OU=HEH-Users,DC=hehs,DC=internal" -Filter * |
Set-ADUser -PasswordNeverExpires $true

Get-ADUser -SearchBase "OU=Teaching Staff,OU=HEH-Users,DC=hehs,DC=internal" -Filter * |
Set-ADUser -PasswordNeverExpires $true