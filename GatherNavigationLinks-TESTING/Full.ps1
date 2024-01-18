function Get-SubNavigationNodes($parentId) {
    $childNodes = $allQuickLaunchNodes | Where-Object { $_.ParentId -eq $parentId }
    $nodeCollection = @()

    foreach ($node in $childNodes) {
        $childItems = Get-SubNavigationNodes $node.Id
        $nodeObject = @{
            'Title' = $node.Title
            'Url'   = $node.Url
            'SubItems' = $childItems
        }
        $nodeCollection += $nodeObject
    }

    return $nodeCollection
}

# Connect to SharePoint Online with Interactive Login (supports 2FA)
$siteUrl = Read-Host "Please enter the SharePoint Site URL"
Connect-PnPOnline -Url $siteUrl -UseWebLogin

# Get all Quick Launch nodes
$allQuickLaunchNodes = Get-PnPNavigationNode -Location QuickLaunch

# Assume nodes with a null or missing ParentId as root nodes
$rootNodes = $allQuickLaunchNodes | Where-Object { -not $_.ParentId }

$menuHierarchy = @()

foreach ($node in $rootNodes) {
    $subItems = Get-SubNavigationNodes $node.Id
    $rootItem = @{
        'Title' = $node.Title
        'Url'   = $node.Url
        'SubItems' = $subItems
    }
    $menuHierarchy += $rootItem
}

# Convert the menu hierarchy to JSON and save
$jsonFilePath = "C:\Temp\menuHierarchy.json" # Update with your desired file path
$jsonContent = $menuHierarchy | ConvertTo-Json -Depth 10 -Compress
Set-Content -Path $jsonFilePath -Value $jsonContent
Write-Host "Menu hierarchy saved to: $jsonFilePath"
