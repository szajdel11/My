try {
    Set-Service -Name w32time -StartupType Automatic
    Start-Service -Name w32time
    # Optionally force a resync:
    w32tm /resync
}
catch {
    Write-Host "Error setting Windows Time service: $_" -ForegroundColor Red
    exit 1
}
exit 0