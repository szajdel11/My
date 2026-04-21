# Remove Appx Packages for all users
$AppsToRemove = @(
    "Microsoft.Copilot"
    "Microsoft.Todos"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.BingNews"
    "Microsoft.Windows.DevHome"
    "Clipchamp.Clipchamp"
    "Microsoft.XboxGameCallableUI"
    "Microsoft.MicrosoftSolitaireCollection"
)
 
foreach ($App in $AppsToRemove) {
    Get-AppxPackage -AllUsers -Name $App | Remove-AppxPackage -AllUsers
    Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like "*$App*" } | Remove-AppxProvisionedPackage -Online
}
