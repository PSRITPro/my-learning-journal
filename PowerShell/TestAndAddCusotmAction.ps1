<#
.SYNOPSIS
    Automates custom action addition, property bag update, and SharePoint list creation/configuration on new SharePoint Online sites.

.DESCRIPTION
    Connects to SharePoint Admin Center, processes newly created sites (last 25 hours), and performs actions such as:
    - Enabling/disabling custom script
    - Adding/updating custom actions
    - Updating property bag values
    - Creating and configuring a SharePoint list
    - Logging actions and errors
    - Exporting new sites to CSV
    - Sending a summary email

.PARAMETER adminSiteUrl
    URL of the SharePoint Online Admin Center.

.PARAMETER customActionName
    Title of the custom action to check or add.

.PARAMETER customActionUrl
    URL to the custom action script file.

.PARAMETER propertyBagKey
    Key of the property bag to update.

.PARAMETER propertyBagValue
    Value to set for the property bag key.

.PARAMETER emailFrom
    Email address to send the summary email from.

.PARAMETER emailTo
    Email address to send the summary email to.

.PARAMETER emailSubject
    Subject line for the summary email.

.PARAMETER smtpServer
    SMTP server for sending the email.

.PARAMETER listName
    Name of the SharePoint list to create and configure.

.PARAMETER logFilePath
    Path to the transaction log file.

.PARAMETER newSitesCsvPath
    Path to the CSV file for new sites.

.NOTES
    - Requires the SharePoint PnP PowerShell module.
    - Ensure correct permissions and accessible file paths.
#>

# Path to the config.json file
$configPath = "C:\path\to\config.json"

# Load the configuration
$config = Get-Content -Path $configPath | ConvertFrom-Json

# Parameters from the config
$adminSiteUrl = $config.AdminSiteUrl
$customActionName = $config.CustomActionName
$customActionUrl = $config.CustomActionUrl
$propertyBagKey = $config.PropertyBagKey
$propertyBagValue = $config.PropertyBagValue
$emailFrom = $config.EmailFrom
$emailTo = $config.EmailTo
$emailSubject = $config.EmailSubject
$smtpServer = $config.SmtpServer
$listName = "YourCustomListName"
$logFilePath = "C:\path\to\logs\transaction_log.txt"
$newSitesCsvPath = "C:\path\to\new_sites\new_sites.csv"

# Prompt for credentials
$cred = Get-Credential

# Collect site status information
$siteStatuses = @()
$failedSites = @()

# Connect to SharePoint Admin Center
Connect-PnPOnline -Url $adminSiteUrl -Credentials $cred

# Define the time window
$startTime = (Get-Date).AddHours(-25)

# Get and filter new site collections
$sites = Get-PnPTenantSite
$newSites = $sites | Where-Object { [datetime]$_.CreationDate -gt $startTime }

# Export new sites to CSV
$newSites | Select-Object Url, CreationDate | Export-Csv -Path $newSitesCsvPath -NoTypeInformation

# Process new sites
foreach ($site in $newSites) {
    $siteUrl = $site.Url
    $status = ""

    try {
        # Log start
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Processing site: $siteUrl"

        # Connect to the new site
        Connect-PnPOnline -Url $siteUrl -Credentials $cred

        # Enable custom script
        Set-PnPSite -Identity $siteUrl -CustomScriptEnabled $true
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Custom script enabled for $siteUrl"

        # Check and add custom action
        $exists = Get-PnPCustomAction | Where-Object { $_.Title -eq $customActionName }
        if (-not $exists) {
            Add-PnPCustomAction -Title $customActionName -ScriptSrc $customActionUrl -Location "ScriptLink" -Sequence 100
            $status += "Custom Action added."
            Add-Content -Path $logFilePath -Value "$(Get-Date) - Custom Action '$customActionName' added on $siteUrl"
        } else {
            $status += "Custom Action already exists."
            Add-Content -Path $logFilePath -Value "$(Get-Date) - Custom Action '$customActionName' exists on $siteUrl"
        }

        # Update property bag value
        Set-PnPPropertyBagValue -Key $propertyBagKey -Value $propertyBagValue
        $status += " Property Bag updated."
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Property Bag '$propertyBagKey' updated on $siteUrl"

        # Create and configure SharePoint list
        New-PnPList -Title $listName -Template GenericList -OnQuickLaunch $false
        $list = Get-PnPList -Identity $listName
        $web = Get-PnPWeb

        # Configure list permissions
        $adminRole = $web.RoleDefinitions | Where-Object { $_.Name -eq "Full Control" }
        $readRole = $web.RoleDefinitions | Where-Object { $_.Name -eq "Read" }
        $adminGroup = $web.SiteGroups | Where-Object { $_.Title -eq "Site Collection Administrators" }
        $ownersGroup = $web.SiteGroups | Where-Object { $_.Title -eq "Site Owners" }

        $list.RoleAssignments.Add($adminGroup, $adminRole)
        $list.RoleAssignments.Add($ownersGroup, $readRole)
        $list.Context.ExecuteQuery()

        # Disable custom script
        Set-PnPSite -Identity $siteUrl -CustomScriptEnabled $false
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Custom script disabled for $siteUrl"

        # Disconnect from the site
        Disconnect-PnPOnline

        # Store status
        $siteStatuses += [PSCustomObject]@{
            SiteUrl = $siteUrl
            Status = $status
        }
        # Log success
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Successfully processed $siteUrl"
    }
    catch {
        # Log error
        $failedSites += [PSCustomObject]@{
            SiteUrl = $siteUrl
            Error = $_.Exception.Message
        }
        Add-Content -Path $logFilePath -Value "$(Get-Date) - Error processing $siteUrl: $($_.Exception.Message)"
    }
}

# Disconnect from SharePoint Admin Center
Disconnect-PnPOnline

# Compile email body
$emailBody = "Summary of updates and failures:`n`n"
foreach ($siteStatus in $siteStatuses) {
    $emailBody += "Site URL: $($siteStatus.SiteUrl)`nStatus: $($siteStatus.Status)`n`n"
}

if ($failedSites.Count -gt 0) {
    $emailBody += "Failed Sites:`n`n"
    foreach ($failedSite in $failedSites) {
        $emailBody += "Site URL: $($failedSite.SiteUrl)`nError: $($failedSite.Error)`n`n"
    }
}

# Send summary email
Send-MailMessage -From $emailFrom -To $emailTo -Subject $emailSubject -Body $emailBody -SmtpServer $smtpServer

Write-Output "Email sent with summary of updates and failures."
