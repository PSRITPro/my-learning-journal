# PowerShell Learning Plan

## Overview of PowerShell
PowerShell is a task automation framework that combines a command-line shell with a scripting language designed for system administration. It enables users to automate tasks and manage configurations in a consistent and efficient manner.

## History of PowerShell

### Initial Release (2006)
Introduced as **Windows PowerShell 1.0**, it aimed to address the limitations of the traditional Command Prompt and provide a more powerful scripting environment. Key features included cmdlets, pipelines, and the ability to work with .NET objects.

### Key Versions
- **PowerShell 2.0 (2009)**: Added remoting capabilities and the Integrated Scripting Environment (ISE) for easier script development.
- **PowerShell 3.0 (2012)**: Introduced workflows, enhanced debugging, and improved cmdlet discovery.
- **PowerShell 4.0 (2013)**: Featured Desired State Configuration (DSC) for configuration management.
- **PowerShell 5.0 (2016)**: Included support for Windows Management Framework (WMF) and new cmdlets for managing cloud services.
- **PowerShell Core (2016)**: Launched as a cross-platform version, compatible with macOS and Linux, marking a significant shift toward open-source.

## Role in Automation and System Administration
PowerShell plays a crucial role in modern IT environments, especially for system administrators and DevOps professionals. Here are some key roles it fulfills:

### Task Automation
Automate repetitive administrative tasks such as user management, backups, and updates.  
**Example**: A simple script to create multiple user accounts can save hours of manual work.

```powershell
$users = @("user1", "user2", "user3")
foreach ($user in $users) {
    New-LocalUser -Name $user -Password (ConvertTo-SecureString "P@ssword" -AsPlainText -Force)
}