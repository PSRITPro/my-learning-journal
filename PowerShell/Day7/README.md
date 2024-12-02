# PowerShell Scripting

### 1. What is PowerShell Scripting?

PowerShell scripting involves using a set of commands, including cmdlets and functions, within the PowerShell environment to automate various tasks. These scripts are typically stored in .ps1 files and can be executed multiple times to perform repetitive tasks more efficiently.

PowerShell scripting is a powerful tool for system administrators and IT professionals, allowing them to manage users, files, processes, and other system resources automatically. By automating these tasks, PowerShell reduces manual effort, minimizes the risk of human error, and improves overall productivity.

Key Components:

    Cmdlets: Small, single-function commands built into PowerShell (e.g., Get-Process, Set-Location).

    Functions: Custom reusable blocks of code written by the user to perform complex tasks.

    Variables: Temporary data storage used to hold values or objects (e.g., $userName, $diskSpace).

    Pipelines: Pass data from one cmdlet to another, enabling the composition of complex tasks.


### 2. Why Use PowerShell Scripting?

- **Repetitive Tasks**  
  PowerShell scripting is an effective solution for automating repetitive tasks. For example, if you frequently need to generate reports, copy files, or manage user accounts, scripting can handle these tasks automatically. By writing a script, these tasks can be executed with just a single command, saving you valuable time and allowing you to focus on more complex or important work. Automation helps remove the monotony and ensures that repetitive tasks are completed efficiently.

- **Consistency**  
  Another major benefit of PowerShell scripting is **consistency**. When you create a script to handle a task, it ensures the task is executed in the same way every time. This eliminates variations that may occur with manual intervention, significantly reducing the risk of human error. Whether you're managing systems, creating users, or generating reports, PowerShell guarantees that the process is repeated accurately, which is vital for maintaining stable and reliable operations.

- **Scalability**  
  PowerShell scripts are highly scalable, making them perfect for handling larger tasks or managing multiple systems. For instance, you might need to manage thousands of users across different servers or handle large datasets. PowerShell can efficiently scale to handle these tasks, ensuring that even as your environment grows, the scripts remain effective. The ability to manage a large number of systems simultaneously with a single script is one of PowerShell's strongest advantages.

- **Efficiency**  
  PowerShell scripting greatly enhances **efficiency** by eliminating the need to perform manual steps repeatedly. Instead of having to carry out each step in a process manually, a script automates the entire workflow, reducing the time spent on tasks and improving overall productivity. Whether it’s deploying software, updating systems, or generating reports, PowerShell makes these operations faster and more reliable, which boosts overall system management efficiency.

- **Error Reduction**  
  One of the most significant advantages of automating tasks with PowerShell is the reduction in **human error**. By ensuring that tasks are executed in the same way every time, scripts help maintain a consistent process. Manual tasks can often lead to mistakes—whether it’s an incorrect file copy, a missed step, or a forgotten configuration. Scripting eliminates these errors by following a predetermined set of instructions each time the task runs, making your IT operations more reliable and secure.

### 3. Benefits of PowerShell Scripting

- **Time-Saving**  
  One of the biggest advantages of using PowerShell scripting is the time-saving aspect. Once a script is written, it can be executed with a single command. This eliminates the need for manual intervention, allowing administrators to automate repetitive tasks. For example, instead of manually checking system statuses or gathering reports, PowerShell allows you to run a script to complete these tasks automatically, freeing up valuable time for more complex work.

- **Flexibility**  
  PowerShell's flexibility is another key benefit. It can be used to manage a variety of systems, including local machines, remote systems, and even cloud resources such as Azure and AWS. Whether you're managing on-premises servers or cloud-based services, PowerShell provides a unified toolset that works across multiple platforms, making it an essential tool for today's diverse IT environments.

- **Customization**  
  PowerShell scripts are highly customizable, meaning they can be tailored to meet the specific needs of any workflow. For example, you can write scripts that automate data backups, deploy applications, or perform complex network diagnostics—all adjusted to fit the unique requirements of your environment. This level of customization makes PowerShell an incredibly versatile tool for IT admins, cloud admins, and database admins alike.

- **Scheduled Execution**  
  Another powerful feature of PowerShell is its ability to schedule scripts for automatic execution. For instance, you can set up a script to run at specific intervals, such as daily or weekly, without needing to manually start the process. This is particularly useful for recurring tasks like system health checks, patch management, or data synchronization, ensuring tasks are completed on time without requiring constant oversight.

- **Remote Management**  
  PowerShell is built to support remote management, which means administrators can execute scripts on remote servers and workstations. This is especially useful in large environments where managing individual machines manually would be time-prohibitive. With PowerShell, you can connect to remote systems securely, run scripts, and manage resources from a centralized location, streamlining workflows and reducing the need for on-site intervention.

### 4. Use Cases of PowerShell Scripting

- **System Administration**  
  Automating routine system maintenance, software installations, user management, and more.

- **Cloud Management**  
  Managing cloud resources in Azure, AWS, or Google Cloud.

- **DevOps Automation**  
  Automating build, test, and deployment pipelines.

- **Network Management**  
  Managing network configurations and devices.

- **Report Generation**  
  Automating data collection and report generation from logs or databases.

- **Backup and Recovery**  
  Automating backup processes and restoring files or system states.


### 5. Examples

- **Hello World**

we’re going to start with one of the simplest examples in PowerShell scripting—the "Hello World" script. This example is traditionally the first program written by beginners in most programming languages, and it serves as a good introduction to scripting in PowerShell.

Open Powerhell ISE

```powersehll
# This is a simple Hello World script in PowerShell
Write-Host "Hello, World!"
```
Save as HelloWorld.ps1 file, run script file.

- **Get system information**

```powersehll
# Simple script to get system information

# Get the computer name
$ComputerName = $env:COMPUTERNAME

# Get the current logged-in user
$LoggedInUser = $env:USERNAME

# Output the system information
Write-Host "Computer Name: $ComputerName"
Write-Host "Logged-In User: $LoggedInUser"
```

- **List-Files**

```powersehll
# Simple script to get system information

# Get the computer name
# Script to list all files in a specified directory and show their size

# Specify the directory
$DirectoryPath = "C:\path\to\your\directory"

# Get all files in the directory
$Files = Get-ChildItem -Path $DirectoryPath -File

# Loop through each file and display its name and size
foreach ($File in $Files) {
    Write-Host "File: $($File.Name) - Size: $([math]::round($File.Length / 1MB, 2)) MB"
}
```

- **Backup-Directory**

```powersehll
# Script to backup a directory to a specified backup location

# Specify the source directory (the directory you want to backup)
$SourceDirectory = "C:\path\to\source\directory"

# Specify the destination backup directory
$BackupDirectory = "C:\path\to\backup\directory"

# Check if the source directory exists
if (Test-Path -Path $SourceDirectory) {
    
    # Check if the backup directory exists, if not, create it
    if (-not (Test-Path -Path $BackupDirectory)) {
        New-Item -Path $BackupDirectory -ItemType Directory
        Write-Host "Backup directory created: $BackupDirectory"
    }
    
    # Copy the contents from the source to the backup directory
    try {
        Copy-Item -Path $SourceDirectory\* -Destination $BackupDirectory -Recurse -Force
        Write-Host "Backup successful! Files copied from $SourceDirectory to $BackupDirectory"
    } catch {
        Write-Host "Error during backup: $_"
    }
    
} else {
    Write-Host "Source directory does not exist: $SourceDirectory"
}
```

- **Monitor-DiskSpace**

```powersehll
# Script to monitor disk space and alert if usage exceeds a specified threshold

# Specify the threshold for disk usage in percentage
$Threshold = 80

# Get all the logical drives on the system
$Drives = Get-WmiObject Win32_LogicalDisk -Filter "DriveType = 3"

# Loop through each drive and check its usage
foreach ($Drive in $Drives) {
    # Calculate the percentage of used space
    $UsedSpacePercentage = ($Drive.Size - $Drive.FreeSpace) / $Drive.Size * 100

    # If used space exceeds the threshold, send an alert
    if ($UsedSpacePercentage -gt $Threshold) {
        Write-Host "ALERT: Drive $($Drive.DeviceID) is at $([math]::round($UsedSpacePercentage, 2))% usage!"
    } else {
        Write-Host "Drive $($Drive.DeviceID) usage is normal: $([math]::round($UsedSpacePercentage, 2))%"
    }
}
```