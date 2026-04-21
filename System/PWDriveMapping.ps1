$DriveLetter = "Drive Letter"

if (-not(Test-Path $DriveLetter)) {
$User = "SERVER\USERNAME"
$Password = "Password"
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($User, $SecurePassword)
New-PSDrive -Name $DriveLetter -PSProvider FileSystem -Root \\$User -Credential $Credential -Persist

#Make a shortcut to an App in the mapped drive in the user's Programs folder
$UserProgramsFolder = [System.Environment]::GetFolderPath('Programs')
$UserProgramsShortcutPath = Join-Path -Path $UserProgramsFolder -ChildPath "InVentry.lnk"
$TargetPath = "I:\V4\Console\InVentryConsole.exe"
$WScriptShell = New-Object -ComObject WScript.Shell
$UserProgramsShortcut = $WScriptShell.CreateShortcut($UserProgramsShortcutPath)
$UserProgramsShortcut.TargetPath = $TargetPath
$UserProgramsShortcut.Save()
} else {
    exit
}

