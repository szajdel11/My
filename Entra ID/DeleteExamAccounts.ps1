Connect-MgGraph -Scopes "User.ReadWrite.All"

Get-MgUser -Filter "startsWith(userPrincipalName,'ExamAccount')" |
ForEach-Object {
    Remove-MgUser -UserId $_.Id
}

# Permanently delete from recycle bin CAUTION!!!
Get-MgDirectoryDeletedItem |
Where-Object {$_.UserPrincipalName -like "ExamAccount*"} |
ForEach-Object {
    Remove-MgDirectoryDeletedItem -DirectoryObjectId $_.Id
}
