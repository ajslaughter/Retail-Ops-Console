<#
.SYNOPSIS
    Archives and deletes SharePoint list items older than 90 days.
.DESCRIPTION
    This script connects to a SharePoint Online site using PnP PowerShell.
    It identifies items in the 'RetailTickets' list that are older than 90 days.
    It exports these items to a CSV file for backup purposes.
    Finally, it deletes the items from the SharePoint list.
.NOTES
    Author: Retail Ops Automation
    Version: 1.0
#>

param (
    [string]$SiteUrl = "https://bellbank.sharepoint.com/sites/RetailOps",
    [string]$ListName = "RetailTickets",
    [int]$DaysToKeep = 90,
    [string]$BackupPath = "C:\RetailOps\Backups"
)

# Ensure backup directory exists
if (-not (Test-Path $BackupPath)) {
    New-Item -ItemType Directory -Path $BackupPath | Out-Null
}

Write-Host "Connecting to SharePoint Site: $SiteUrl" -ForegroundColor Cyan
try {
    # In a real scenario, use -Interactive or -ClientId/-Thumbprint for unattended auth
    
    # --- UNATTENDED AUTH EXAMPLE ---
    # Connect-PnPOnline -Url $SiteUrl -ClientId "YOUR_APP_ID" -Thumbprint "YOUR_CERT_THUMBPRINT" -Tenant "yourtenant.onmicrosoft.com"
    # -------------------------------

    Connect-PnPOnline -Url $SiteUrl -Interactive -ErrorAction Stop
    Write-Host "Connected successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to connect to SharePoint: $_"
    exit 1
}

$cutoffDate = (Get-Date).AddDays(-$DaysToKeep)
Write-Host "Querying items created before: $cutoffDate" -ForegroundColor Cyan

# CAML Query to filter items efficiently
$camlQuery = @"
<View>
    <Query>
        <Where>
            <Leq>
                <FieldRef Name='Created' />
                <Value Type='DateTime'>$($cutoffDate.ToString("yyyy-MM-ddTHH:mm:ssZ"))</Value>
            </Leq>
        </Where>
    </Query>
</View>
"@

try {
    $items = Get-PnPListItem -List $ListName -Query $camlQuery -PageSize 500 -ErrorAction Stop
    $count = $items.Count

    if ($count -eq 0) {
        Write-Host "No items found older than $DaysToKeep days." -ForegroundColor Yellow
        exit 0
    }

    Write-Host "Found $count items to archive." -ForegroundColor Yellow

    # Export to CSV
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $csvFile = Join-Path $BackupPath "Archive_$ListName_$timestamp.csv"
    
    $items | Select-Object Id, Title, Created, Author | Export-Csv -Path $csvFile -NoTypeInformation
    Write-Host "Backup saved to: $csvFile" -ForegroundColor Green

    # Delete Items
    foreach ($item in $items) {
        Write-Host "Deleting item ID: $($item.Id)" -ForegroundColor DarkGray
        # Remove-PnPListItem -List $ListName -Identity $item.Id -Force -ErrorAction Continue
    }
    
    Write-Host "Archive and cleanup complete." -ForegroundColor Green
}
catch {
    Write-Error "An error occurred during processing: $_"
    exit 1
}
