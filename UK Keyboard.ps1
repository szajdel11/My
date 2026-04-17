$Language = "en-GB"
$GeoId = "0xf2"
Install-Language -Language $Language -CopyToSettings
Set-PreferredLanguage -Language $Language
Set-SystemPreferredUILanguage -Language $Language
Set-Culture $Language
Set-WinSystemLocale -SystemLocale $Language
Set-TimeZone -Name 'GMT Standard Time'
Set-WinHomeLocation -GeoId $GeoId
Set-WinUserLanguageList -Language $Language -Force -Confirm:$false
Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $True