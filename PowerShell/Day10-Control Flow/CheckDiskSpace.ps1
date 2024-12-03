# Set the threshold for free space in GB
$threshold = 10

# Get disk information for C: drive
$disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'"

# Convert the free space from bytes to GB
$freeSpaceGB = [math]::round($disk.FreeSpace / 1GB, 2)

$smtpServer = "smtp.gmail.com"
$smtpPort = 587
$from = "pssreddy01@gmail.com"
$to = "psrsp01@sptrains.onmicrosoft.com"
$passwordFile = "Pass.txt"
$subject = "Disk Space Alert"
$body = ""

# Check the free space and display appropriate message
if ($freeSpaceGB -lt $threshold) {
    $message = "Warning: Low disk space on C: drive. Free space: $freeSpaceGB GB"
    $body = "Disk space on C: drive is below the threshold. $message"
    Write-Host $message -ForegroundColor Red
    
    # Send an email notification
    Send-MailMessage -SmtpServer $smtpServer -From $from -To $to -Subject $subject -Body $body -BodyAsHtml
} elseif ($freeSpaceGB -eq $threshold) {
    $message = "Alert: Disk space on C: drive is exactly $threshold GB."
    $body = "Disk space on C: drive is exactly at the threshold. $message"
    Write-Host $message -ForegroundColor Yellow

    # Send an email notification
    Send-MailMessage -SmtpServer $smtpServer -From $from -To $to -Subject $subject -Body $body -BodyAsHtml
} else {
    $message = "Success: Sufficient disk space on C: drive. Free space: $freeSpaceGB GB"
    $body = "Disk space on C: drive is sufficient. $message"
    Write-Host $message -ForegroundColor Green
    
    # Send an email notification
    Send-MailMessage -SmtpServer $smtpServer -From $from -To $to -Subject $subject -Body $body -BodyAsHtml
}