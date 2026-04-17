$DriveLetter = "I:"

if (-not(Test-Path $DriveLetter)) {
$User = "10.112.44.35\Inventry"
$Password = "Inventry1983"
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($User, $SecurePassword)
New-PSDrive -Name I -PSProvider FileSystem -Root \\10.112.44.35\inventry -Credential $Credential -Persist
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

