# Set the threshold for free space in GB
$threshold = 10

# Get disk information for C: drive
$disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'"

# Convert the free space from bytes to GB
$freeSpaceGB = [math]::round($disk.FreeSpace / 1GB, 2)

$smtpServer = "smtp.gmail.com"
$smtpPort = 587
$from = "pssreddy01@gmail.com"
#$to = "psrsp01@sptrains.onmicrosoft.com"
$to = "pssreddy01@gmail.com"
$passwordFile = "Pass.txt"
$subject = "Disk Space Alert"
$body = ""

# Read the password from a file
$txt = Get-Content $passwordFile
$securePassword = ConvertTo-SecureString $txt -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($from, $securePassword)

# Check the free space and display appropriate message
if ($freeSpaceGB -lt $threshold) {
    $message = "Warning: Low disk space on C: drive. Free space: $freeSpaceGB GB"
    $body = "Disk space on C: drive is below the threshold. $message"
    Write-Host $message -ForegroundColor Red
    
    # Send an email notification
    Send-MailMessage -From $from -To $to -Subject $subject -Body $body -BodyAsHtml -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $credential -Priority High
} elseif ($freeSpaceGB -eq $threshold) {
    $message = "Alert: Disk space on C: drive is exactly $threshold GB."
    $body = "Disk space on C: drive is exactly at the threshold. $message"
    Write-Host $message -ForegroundColor Yellow

    # Send an email notification
    Send-MailMessage -From $from -To $to -Subject $subject -Body $body -BodyAsHtml -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $credential -Priority High
} else {
    $message = "Success: Sufficient disk space on C: drive. Free space: $freeSpaceGB GB"
    $body = "Disk space on C: drive is sufficient. $message"
    Write-Host $message -ForegroundColor Green
    
    # Send an email notification
    Send-MailMessage -From $from -To $to -Subject $subject -Body $body -BodyAsHtml -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $credential -Priority High
}