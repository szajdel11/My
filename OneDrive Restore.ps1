# Login to Graph with required scopes
Connect-MgGraph -Scopes "GroupMember.Read.All", "User.Read.All", "Files.ReadWrite.All", "Sites.ReadWrite.All"

# Function for throttled API calls with exponential backoff
function Invoke-WithRetry {
    param (
        [scriptblock]$ScriptBlock,
        [int]$MaxRetries = 5
    )
    $retryCount = 0
    $delay = 2
    while ($retryCount -lt $MaxRetries) {
        try {
            return & $ScriptBlock
        } catch {
            if ($_.Exception.Response.StatusCode -eq 429 -or $_.Exception.Response.StatusCode -eq 503) {
                Write-Warning "Throttled. Retrying in $delay seconds..."
                Start-Sleep -Seconds $delay
                $retryCount++
                $delay = [Math]::Min($delay * 2, 60)  # Cap at 60s
            } else {
                throw $_
            }
        }
    }
    throw "Maximum retry attempts reached."
}

# Replace with the actual display name of your group
$groupName = "AllStudents"

# Get the group by displayName (exact match)
$group = Get-MgGroup -Filter "displayName eq '$groupName'"
if (-not $group) {
    Write-Error "Group '$groupName' not found."
    return
}

# Confirm group info
Write-Host "Found group: $($group.DisplayName) with ID: $($group.Id)"

# Get all members (paged)
$members = @()
$response = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/groups/$($group.Id)/members"
$members += $response.value
while ($response.'@odata.nextLink') {
    $response = Invoke-MgGraphRequest -Method GET -Uri $response.'@odata.nextLink'
    $members += $response.value
}

Write-Host "🧑‍🎓 Total students found: $($members.Count)"

# Log storage
$log = @()

foreach ($member in $members) {
    $userId = $member.id
    $upn = $member.userPrincipalName
    Write-Host "`n🔄 Processing: $upn"
    try {
        # Get user's OneDrive root
        $drive = Invoke-WithRetry {
            Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/users/$userId/drive"
        }
        if (-not $drive) {
            Write-Warning "⚠️ No OneDrive found for $upn"
            $log += [PSCustomObject]@{User=$upn; Status="No OneDrive"; ItemsRestored=0; Error=""}
            continue
        }

        # Get recycle bin items from the correct endpoint
        $deletedItems = Invoke-WithRetry {
            Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/users/$userId/drive/root/deleted"
        }

        if ($deletedItems.value.Count -eq 0) {
            Write-Host "🧼 Nothing to restore for $upn"
            $log += [PSCustomObject]@{User=$upn; Status="Empty Recycle Bin"; ItemsRestored=0; Error=""}
            continue
        }

        $restoredCount = 0
        foreach ($item in $deletedItems.value) {
            Invoke-WithRetry {
                Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/users/$userId/drive/items/$($item.id)/restore"
            }
            $restoredCount++
        }

        Write-Host "✅ Restored $restoredCount items for $upn"
        $log += [PSCustomObject]@{User=$upn; Status="Success"; ItemsRestored=$restoredCount; Error=""}
    }
    catch {
        Write-Error "❌ Error processing ${upn}: $($_.Exception.Message)"
        $log += [PSCustomObject]@{User=$upn; Status="Error"; ItemsRestored=0; Error=$_.Exception.Message}
    }
    Start-Sleep -Milliseconds 500
}

# Save log to file
$log | Export-Csv -Path "C:\OneDriveRestoreLog.csv" -NoTypeInformation
Write-Host "`n📄 Log saved to OneDriveRestoreLog.csv"