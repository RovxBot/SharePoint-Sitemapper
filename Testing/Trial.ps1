# Import SharePoint PnP module
Import-Module SharePointPnPPowerShellOnline

# Prompt for SharePoint Site URL
$siteUrl = Read-Host "Please enter the SharePoint Site URL"

# Connect to SharePoint Online with Interactive Login (supports 2FA)
Connect-PnPOnline -Url $siteUrl -UseWebLogin

# Get all Quick Launch nodes
$allQuickLaunchNodes = Get-PnPNavigationNode -Location QuickLaunch

# Display each node
Write-Host "All Quick Launch Nodes:"
foreach ($node in $allQuickLaunchNodes) {
    Write-Host "Title: $($node.Title), URL: $($node.Url), ParentId: $($node.ParentId)"
}

# Check if we have any nodes
if ($allQuickLaunchNodes.Count -eq 0) {
    Write-Host "No Quick Launch nodes found."
} else {
    Write-Host "Total Quick Launch nodes found: $($allQuickLaunchNodes.Count)"
}
