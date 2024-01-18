# Import SharePoint PnP module
Import-Module SharePointPnPPowerShellOnline

# Prompt for SharePoint Site URL
$siteUrl = Read-Host "Please enter the SharePoint Site URL"

# Connect to SharePoint Online with Interactive Login (supports 2FA)
Connect-PnPOnline -Url $siteUrl -UseWebLogin

# Get all Quick Launch nodes
$allQuickLaunchNodes = Get-PnPNavigationNode -Location QuickLaunch

# Output all nodes for inspection
Write-Host "All Quick Launch Nodes:"
$allQuickLaunchNodes | Select-Object Title, Url, ParentId | Format-Table -AutoSize

# Attempt to filter out the top-level nodes assuming ParentId for top-level is 0 or null
$rootNodes = $allQuickLaunchNodes | Where-Object { $_.ParentId -eq 0 -or $_.ParentId -eq $null }
Write-Host "Filtered Root Nodes:"
$rootNodes | Select-Object Title, Url, ParentId | Format-Table -AutoSize

# Check if we have root nodes
if ($rootNodes.Count -eq 0) {
    Write-Host "No root nodes found. This may indicate that the ParentId is not 0 or null for top-level nodes, or that there are no nodes set up as expected."
} else {
    Write-Host "Found $($rootNodes.Count) root nodes."
    # Further processing would go here...
}
