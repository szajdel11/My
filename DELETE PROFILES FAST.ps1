$profiles = Get-ChildItem "C:\Users" | Where-Object { $_.Name -notmatch "Administrator|Public|Default|SZajdel_ad" }

foreach ($profile in $profiles) {
    $profilePath = "C:\Users\$($profile.Name)"
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

    # Find and delete registry key associated with the profile
    $profileKey = Get-ChildItem $regPath | Where-Object { (Get-ItemProperty $_.PSPath).ProfileImagePath -eq $profilePath }
    if ($profileKey) {
        Remove-Item -Path $profileKey.PSPath -Force -Recurse
    }

    # Force delete the profile folder
    Remove-Item -Path $profilePath -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "Deleted: $profilePath"
}
shutdown -r -t 600