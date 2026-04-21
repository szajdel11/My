# Stop Xbox-related processes
$XboxProcesses = "Xbox", "GameBar", "XboxGameOverlay", "XboxApp", "GamingServices"
foreach ($process in $XboxProcesses) {
    Get-Process -Name $process -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}
 
# Uninstall Xbox and gaming services for all users
$XboxApps = @(
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.GamingApp", # New Xbox App
    "Microsoft.XboxApp",
    "Microsoft.GamingServices"
)
 
foreach ($app in $XboxApps) {
    Get-AppxPackage -AllUsers | Where-Object { $_.Name -like $app } | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
}
 
# Remove provisioned packages (pre-installed Xbox apps)
foreach ($app in $XboxApps) {
    Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $app } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}
 
# Uninstall Gaming Services via registry (prevents auto-reinstall)
$GamingServices = "HKLM:\SYSTEM\CurrentControlSet\Services\GamingServices"
$GamingServicesNet = "HKLM:\SYSTEM\CurrentControlSet\Services\GamingServicesNet"
if (Test-Path $GamingServices) { Remove-Item -Path $GamingServices -Recurse -Force }
if (Test-Path $GamingServicesNet) { Remove-Item -Path $GamingServicesNet -Recurse -Force }
 
# Stop and disable Xbox services
$services = @(
    "XblAuthManager",
    "XblGameSave",
    "XboxGipSvc",
    "XboxNetApiSvc"
)
 
foreach ($service in $services) {
    Get-Service -Name $service -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue
    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue
}
 
