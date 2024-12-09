# Introduction to PowerShell Loops

## Introduction to PowerShell Loops
In PowerShell, loops are used to execute a block of code multiple times based on a certain condition. Loops help automate repetitive tasks and simplify the code. They are one of the core control structures in programming, allowing the execution of specific code until a condition is met or for a predefined number of iterations.

PowerShell provides several types of loops, each suited to different use cases:

## Types of PowerShell Loops

- **For Loop**
- **While Loop**
- **Do-While Loop**
- **Do-Until Loop**
- **ForEach Loop**

Let’s dive into each one.


## 1. For Loop
The For loop is used when the number of iterations is known beforehand. This is ideal for situations where you need to execute a block of code a specific number of times.

Syntax of the For Loop:

```powershell
for ($i = 0; $i -lt 5; $i++) {
    Write-Host "Iteration $i"
}
```

### Key Elements:
- **Initialize counter:** ($i = 0), This sets the initial value of the counter variable ($i). It’s where you start the loop.

- **Set condition:** ($i -lt 5), The condition ($i -lt 5) is checked before each iteration. As long as this condition is true, the loop will continue. Once $i is equal to or greater than 5, the loop stops.

- **Increment counter:** ($i++), After each iteration, the counter ($i) is incremented by 1 ($i++). This ensures the loop progresses through each iteration.

### Some of the use cases
- Batch Rename Files in a Directory
- Send Bulk Emails
- Ping Multiple Servers/Hosts
- Automate Backup of Files/Folders
- Modify Registry Keys

## 2. Foreach Loop
The foreach loop is commonly used in PowerShell to iterate over each item in a collection, array, or other enumerable objects, making it a very efficient way to process a series of items without manually managing index variables like in a for loop.

Syntax of the For Loop:

```powershell
f$numbers = 1..5
foreach ($num in $numbers) {
    Write-Host "Number: $num"
}
```
- $numbers = 1..5 initializes an array of numbers from 1 to 5.
- The foreach loop begins with foreach ($num in $numbers). This means for each item in $numbers, PowerShell will: 
    - Assign the current item (1, then 2, and so on) to the $num variable.
    - Execute the block of code within the loop for each item.
- Inside the loop, Write-Host "Number: $num" prints the current number to the console.

### Key Elements:
- **Collection Iteration:** The foreach loop is ideal when you want to process each item in a collection or array.
- **No Indexing Required:** Unlike a for loop, you don't need to manage an index counter. You simply specify the collection and the iterator variable (e.g., $num).
- **Simplified Code:** It's generally more readable and less error-prone than a for loop, especially when you don’t need access to the index of the item being processed.

### Some of the use cases
- Batch Rename Files in a Directory
- Send Bulk Emails
- Ping Multiple Servers/Hosts
- Automate Backup of Files/Folders

## 3. While Loop
The while loop in PowerShell is used to repeatedly execute a block of code as long as a specified condition evaluates to true. It’s particularly useful for scenarios where you don’t know the number of iterations in advance but want to keep running the loop until a certain condition is no longer satisfied.

Syntax of the For Loop:

```powershell
$i = 0
while ($i -lt 5) {
    Write-Host "Iteration $i"
    $i++
}
```

- $i = 0 initializes the loop counter variable $i to 0. This is the starting point of the loop.
- The condition $i -lt 5 checks if $i is less than 5. Since $i is 0, the condition is true, so the loop body runs.
- Write-Host "Iteration $i" outputs the current value of $i to the console.
- $i++ increments $i by 1 after each iteration. This is essential for ensuring that the condition eventually becomes false and the loop terminates.
- After the first iteration, $i becomes 1, and the loop checks if $i is still less than 5. Since it is, the loop continues for additional iterations until $i reaches 5.

Important Notes:

- The loop checks the condition before each iteration, meaning if the condition is false initially, the loop will never execute.
- Without the $i++ statement, the loop would run infinitely, as the value of $i would never change and the condition would always be true.
- The loop exits as soon as the condition evaluates to false.

### Key Elements:
- **Condition is Checked Before Each Iteration:** The condition is evaluated before each loop execution. If it's false initially, the loop won't run.
- **Must Avoid Infinite Loops:** It's important to ensure that the condition will eventually become false by updating relevant variables or state inside the loop. If this isn't done, the loop will run infinitely.
- **Flexibility:** The while loop is useful when you don't know exactly how many times you need to repeat the block of code and only want to keep running while a condition holds true.

### Some of the use cases
- Monitoring System Resource Usage

    ```powershell
    while ($true) {
        $cpuUsage = Get-WmiObject Win32_Processor | Select-Object -ExpandProperty LoadPercentage
        if ($cpuUsage -gt 90) {
            Write-Host "CPU usage is high: $cpuUsage%"
            break
        }
        Start-Sleep -Seconds 1
    }

    # (depended for above script)
    #Create multiple jobs to simulate higher CPU usage
    1..8 | ForEach-Object {
        Start-Job -ScriptBlock {
            while ($true) {
                [Math]::Sqrt(123456789)
            }
        }
    }

    ```
- Polling for User Input
    ```powershell
    $input = ""
    while ($input -eq "") {
        $input = Read-Host "Please enter your name"
    }
    Write-Host "Hello, $input!"
    ```