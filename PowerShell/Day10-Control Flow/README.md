# PowerShell Control Flow

## 1. Intoduction

### 1.1 Key Points:

- **Control Flow** refers to the decision-making structures that determine the execution path of a script.
- It **directs the flow of execution** by making decisions based on conditions.
- **Executes code** based on true/false conditions.
- You can **combine conditions** with **Logical Operators**:
  - `-and`: Both conditions must be true.
  - `-or`: At least one condition must be true.
  - `-not`: Negates the condition, making true conditions false and vice versa.
- You can **compare values** with **Comparison Operators**:
  - `-eq`: Equal to.
  - `-ne`: Not equal to.
  - `-gt`: Greater than.
  - `-lt`: Less than.
  - `-ge`: Greater than or equal to.
  - `-le`: Less than or equal to.

### 1.2 Key Constructs:

- **if, elseif, else**: Make decisions based on conditions.
- **switch**: Handles multiple conditions.

## 2. Conditional Statements

### 2.1 Conditional Statements (if, elseif, else)

- Conditional statements are used to make decisions in a script, allowing the execution of different blocks of code based on whether certain conditions are met.
- **if:** The `if` statement evaluates a condition. If the condition is true, the block of code inside the `if` statement is executed.
- **elseif:** The `elseif` statement provides an alternative condition to check if the initial `if` condition is false. If the `if` condition is false, PowerShell evaluates the `elseif` condition. If it's true, the associated block of code will execute.
- **else:** The `else` statement is used when none of the conditions in the `if` or `elseif` statements are true. If all conditions are false, the block of code inside `else` will be executed.

### Example:
```powershell
$x = 10
if ($x -gt 5) {
    Write-Host "x is greater than 5"
} elseif ($x -eq 5) {
    Write-Host "x is equal to 5"
} else {
    Write-Host "x is less than 5"
}
```
### 2.2 Conditional Statements (switch)

- The `switch` statement is used to handle multiple conditions or choices in a more structured and readable way compared to using multiple `if-elseif-else` statements.
- It evaluates a variable or expression and compares it against a set of possible values.
- If a match is found, the corresponding block of code is executed.
- The `default` block is an optional part of the `switch` statement that executes when none of the specified values match the evaluated variable or expression.

### Example:
```powershell
$day = "Monday"
switch ($day) {
    "Monday" { Write-Host "Start of the week" }
    "Friday" { Write-Host "End of the week" }
    default { Write-Host "Mid-week" }
}
```

## 3 Advanced Control Flow Features

### 3.1 Nested Conditionals
- Nested conditionals allow you to place `if` statements or other control flow structures inside one another, enabling more complex decision-making.
- This approach is useful when you need to evaluate multiple layers of conditions before deciding on an action.

### Example:
```powershell
$x = 10
if ($x -gt 5) {
    if ($x -lt 15) {
        Write-Host "x is between 5 and 15"
    }
}
```

### 3.2 Logical and Comparison Operators with Nested Conditions

- You can combine logical operators (`-and`, `-or`, `-not`) and comparison operators (`-eq`, `-gt`, `-lt`, etc.) to create more complex conditions for decision-making.
- This allows for intricate checks where multiple conditions must be evaluated together to determine the flow of execution.

### Example:

```powershell
$x = 10
$y = 20
if (($x -gt 5 -and $y -lt 30) -or $y -eq 20) {
    Write-Host "Conditions met!"
}
```

## 4. Examples

### Example 1: Check Disk Space
```powershell
# Set threshold for low disk space (in GB)
$lowDiskSpaceThreshold = 10

# Get the disk space info for the C: drive
$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID = 'C:'"

# Calculate free space in GB
$freeSpaceGB = [math]::round($disk.FreeSpace / 1GB, 2)

# Check if the free space is below the threshold
if ($freeSpaceGB -lt $lowDiskSpaceThreshold) {
    Write-Host "Warning: Disk space is low! Only $freeSpaceGB GB left on the C: drive." -ForegroundColor Red
}
elseif ($freeSpaceGB -eq $lowDiskSpaceThreshold) {
    Write-Host "Alert: Disk space is exactly at the threshold! $freeSpaceGB GB left." -ForegroundColor Yellow
}
else {
    Write-Host "Disk space is sufficient. $freeSpaceGB GB available on the C: drive." -ForegroundColor Green
}
```
This script is designed to monitor the available free space on the C: drive and provide alerts based on the available storage. 

- **Threshold:** The script checks whether the available free space on the C: drive is less than 10 GB. This threshold can be adjusted based on your needs.

- **Get-WmiObject:** The script uses `Get-WmiObject` to fetch disk information for the C: drive. It retrieves details such as the total size and free space available on the drive.

- **If Statements:**The `if` block checks the amount of free space on the C: drive and provides appropriate messaging based on the following conditions:

- **Less than 10 GB**: If the free space is below the threshold, a warning message is displayed in red.
- **Exactly 10 GB**: If the free space is exactly at the threshold, an alert is shown in yellow.
- **Greater than 10 GB**: If the free space is above the threshold, a success message is shown in green.


### Example 2: Check Disk Space and Send Email Alert
```powershell
# Set the threshold for free space in GB
$threshold = 10

# Get disk information for C: drive
$disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'"

# Convert the free space from bytes to GB
$freeSpaceGB = [math]::round($disk.FreeSpace / 1GB, 2)

# Define email parameters
$smtpServer = "smtp.yourserver.com"
$from = "your-email@domain.com"
$to = "recipient@domain.com"
$subject = "Disk Space Alert - C: Drive"
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
```