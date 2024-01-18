# Import SharePoint PnP module
Import-Module SharePointPnPPowerShellOnline

# Variable for SharePoint Site URL
$siteUrl = "https://domain.sharepoint.com/sites/YourSite" # Replace with your SharePoint site URL

# Connect to SharePoint Online with Interactive Login
# This will prompt for credentials and handle 2FA
Connect-PnPOnline -Url $siteUrl -UseWebLogin

# Retrieve all site pages
$pages = Get-PnPListItem -List "Site Pages"

# Initialize a hashtable to store the site map
$siteMap = @{}

foreach ($page in $pages) {
    Write-Host "Processing Page: $($page.FieldValues.Title)"
    $pageId = $page.FieldValues.ID
    Write-Host "Page ID: $pageId"

    if ([string]::IsNullOrEmpty($pageId)) {
        Write-Host "Warning: Page ID is null or empty for page $($page.FieldValues.Title)"
        continue # Skip to the next iteration
    }

    $pageTitle = $page.FieldValues.Title
    $pageContent = $page.FieldValues.CanvasContent1

    # Initialize the entry for this page in the site map if it doesn't exist
    if (-not $siteMap.ContainsKey($pageId)) {
        $siteMap[$pageId] = @{
            'Title' = $pageTitle
            'Links' = @() # Initialize 'Links' as an empty array
        }
    }

    # Use updated regex pattern to match links
    $links = [Regex]::Matches($pageContent, '<a[^>]+href="([^"]+)"').Value

    foreach ($link in $links) {
        # Extract just the URL part of the matched pattern using PowerShell's if statement
        if ($link -match 'href="([^"]+)"') {
            $url = $Matches[1]
            # Add the URL to the 'Links' array for this page
            $siteMap[$pageId].Links += $url
        }
    }
}

# Convert the hashtable to an array of objects
$siteMapArray = @()
foreach ($key in $siteMap.Keys) {
    $siteMapArray += [PSCustomObject]@{
        'PageID' = $key
        'Title'  = $siteMap[$key].Title
        'Links'  = $siteMap[$key].Links
    }
}

# Convert the array of objects to JSON
$jsonFilePath = "C:\Temp\siteMap.json" # Update with your desired file path
$jsonContent = $siteMapArray | ConvertTo-Json -Depth 10
Set-Content -Path $jsonFilePath -Value $jsonContent
Write-Host "Site map saved to: $jsonFilePath"
