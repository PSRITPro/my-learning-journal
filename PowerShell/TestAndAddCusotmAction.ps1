<#
.SYNOPSIS
    Automates SharePoint site updates and logging with timestamp support.

.DESCRIPTION
    Connects to SharePoint Admin Center, processes new sites, performs updates, logs actions, and sends an email summary.
#>

# Set the script location as the current directory
Set-Location $PSScriptRoot

# Path to the config.json file
$configPath = "config.json"

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
$listName = $config.ListName
$logFolderPath = $config.LogFolderPath
$newSitesFolderPath = $config.NewSitesFolderPath
$credentialsFilePath = $config.CredentialsFilePath
$timestampFormat = $config.TimestampFormat

# Generate timestamp based on the format from config
$timestamp = (Get-Date).ToString($timestampFormat)

# Define file paths with timestamp
$logFilePath = "$logFolderPath/transaction_log_$timestamp.txt"
$newSitesCsvPath = "$newSitesFolderPath/new_sites_$timestamp.csv"

# Start logging (overwrite existing file)
Start-Transcript -Path $logFilePath

try {
    # Ensure the log and new sites folders exist
    if (-not (Test-Path -Path $logFolderPath)) {
        New-Item -Path $logFolderPath -ItemType Directory -ErrorAction Stop
        Write-Output "Created log directory: $logFolderPath"
    }

    if (-not (Test-Path -Path $newSitesFolderPath)) {
        New-Item -Path $newSitesFolderPath -ItemType Directory -ErrorAction Stop
        Write-Output "Created new sites directory: $newSitesFolderPath"
    }

    # Load credentials from file
    $cred = Import-Clixml -Path $credentialsFilePath -ErrorAction Stop
    Write-Output "Loaded credentials from file: $credentialsFilePath"

    # Connect to SharePoint Admin Center
    Connect-PnPOnline -Url $adminSiteUrl -Credentials $cred -ErrorAction Stop
    Write-Output "Connected to SharePoint Admin Center: $adminSiteUrl"

    # Define the time window
    $startTime = (Get-Date).AddHours(-25)

    # Get and filter new site collections
    $sites = Get-PnPTenantSite -ErrorAction Stop
    $newSites = $sites | Where-Object { [datetime]$_.CreationDate -gt $startTime }
    Write-Output "Retrieved new sites created in the last 25 hours."

    # Export new sites to CSV
    $newSites | Select-Object Url, CreationDate | Export-Csv -Path $newSitesCsvPath -NoTypeInformation -ErrorAction Stop
    Write-Output "Exported new sites to CSV: $newSitesCsvPath"

    # Process new sites
    foreach ($site in $newSites) {
        $siteUrl = $site.Url
        $status = ""

        try {
            # Log start
            Write-Output "Processing site: $siteUrl"

            # Connect to the new site
            Connect-PnPOnline -Url $siteUrl -Credentials $cred -ErrorAction Stop

            # Enable custom script
            Set-PnPSite -Identity $siteUrl -CustomScriptEnabled $true -ErrorAction Stop
            Write-Output "Custom script enabled for $siteUrl"

            # Check and add custom action
            $exists = Get-PnPCustomAction | Where-Object { $_.Title -eq $customActionName }
            if (-not $exists) {
                Add-PnPCustomAction -Title $customActionName -ScriptSrc $customActionUrl -Location "ScriptLink" -Sequence 100 -ErrorAction Stop
                $status += "Custom Action added."
                Write-Output "Custom Action '$customActionName' added on $siteUrl"
            } else {
                $status += "Custom Action already exists."
                Write-Output "Custom Action '$customActionName' exists on $siteUrl"
            }

            # Update property bag value
            Set-PnPPropertyBagValue -Key $propertyBagKey -Value $propertyBagValue -ErrorAction Stop
            $status += " Property Bag updated."
            Write-Output "Property Bag '$propertyBagKey' updated on $siteUrl"

            # Create and configure SharePoint list
            New-PnPList -Title $listName -Template GenericList -OnQuickLaunch $false -ErrorAction Stop
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
            Set-PnPSite -Identity $siteUrl -CustomScriptEnabled $false -ErrorAction Stop
            Write-Output "Custom script disabled for $siteUrl"

            # Disconnect from the site
            Disconnect-PnPOnline
            Write-Output "Successfully processed $siteUrl"
        } catch {
            # Log error
            Write-Output "Error processing $siteUrl: $($_.Exception.Message)"
        }
    }

    # Disconnect from SharePoint Admin Center
    Disconnect-PnPOnline
    Write-Output "Disconnected from SharePoint Admin Center."

    # Compile email body
    $emailBody = "Summary of updates and failures:`n`n"
    foreach ($siteStatus in $siteStatuses) {
        $emailBody += "Site URL: $($siteStatus.Url)`nStatus: $($siteStatus.Status)`n`n"
    }
    foreach ($failedSite in $failedSites) {
        $emailBody += "Site URL: $($failedSite.SiteUrl)`nError: $($failedSite.Error)`n`n"
    }

    # Send summary email
    Send-MailMessage -From $emailFrom -To $emailTo -Subject $emailSubject -Body $emailBody -SmtpServer $smtpServer -ErrorAction Stop
    Write-Output "Email sent with summary of updates and failures."
} catch {
    Write-Output "Critical error occurred: $($_.Exception.Message)"
} finally {
    # Stop logging
    Stop-Transcript
}

Write-Output "Script execution completed."
