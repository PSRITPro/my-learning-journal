# Parameters
param(
    [string]$siteUrl = "https://sptrains.sharepoint.com/sites/TestSite",
    [string]$clientId = "98b129d0-cde8-4649-a981-550a7fae77b0",
    [string]$clientSecret = "YBDSXmRvznRjZhRoOxp95nm+3ZsONw2tu2M1hHTgvOY=",
    [string]$listName = "DestinationList",
    [string]$title = "Title3",
    [string]$status = "Started"
)


# Connect to SharePoint Online

Connect-PnPOnline -Url $siteUrl -ClientId $clientId -ClientSecret $clientSecret
# Create a new item in the specified list
Add-PnPListItem -List $listName -Values @{
    "Title" = $title
    "Status" = $status
}

# Disconnect from SharePoint Online
Disconnect-PnPOnline
