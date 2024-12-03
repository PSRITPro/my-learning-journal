PowerShell offers powerful ways to filter and sort data that make working with large sets of information efficient. Filtering allows us to narrow down data based on certain conditions, while sorting arranges that data in a specific order, either ascending or descending.

# What is Filtering?

Filtering is the process of selecting a subset of data from a larger collection based on a specific condition. In PowerShell, filtering is often done using the Where-Object cmdlet.

#### Basic Filtering Syntax:

"In PowerShell, the basic syntax for the pipeline is simple. You use the | symbol to link cmdlets together."

Basic Syntax:

```powershell
$collection | Where-Object { <condition> }
```

- $collection can be an array, list, or command output.
- Where-Object evaluates each item in the collection to determine if it meets the specified condition.

Example 1: Filtering Numbers

```powershell
1..10 | Where-Object { $_ -gt 5 }
```

Explanation:

- $_ is a special variable that refers to the current object being evaluated in the pipeline.
- The condition { $_ -gt 5 } returns only numbers greater than 5.

Example 2: Filtering Files by Size

```powershell
Get-ChildItem | Where-Object { $_.Length -gt 1MB }
```

Explanation:

- Get-ChildItem lists files in the current directory.
- $_ refers to the current file, and .Length gives the file size. The -gt 1MB condition selects only files larger than 1MB.

Example 3: Filtering by Multiple Conditions

You can filter with more than one condition. For example, finding files larger than 1MB and modified in the last 7 days:

```powershell
Get-ChildItem | Where-Object { $_.Length -gt 1MB -and $_.LastWriteTime -gt (Get-Date).AddDays(-7) }
```

Explanation:

-and combines the conditions, so both must be true (file size greater than 1MB and modified within the last 7 days).

#### Other Operators in Where-Object:

- -eq (equals)
- -ne (not equal)
- -lt (less than)
- -gt (greater than)
- -like (pattern matching with wildcards)
- -match (regular expressions)

Example 4: filtering for .txt files:

```powershell
Get-ChildItem | Where-Object { $_.Extension -like "*.txt" }
```

# What is Sorting?

Sorting arranges data in a specific order, making it easier to analyze or display. PowerShell provides the Sort-Object cmdlet for this purpose.

Basic Sorting Syntax

```powershell
$collection | Sort-Object <property> [-Descending]
```

- "property" refers to the object property you want to sort by (e.g., Length for file sizes, Name for file names).
- Descending sorts the data in reverse order.

Example 1: Sorting Numbers

- Sorting numbers in ascending order: 

```powershell
10, 5, 8, 1, 3 | Sort-Object
```
- Sorting numbers in descending order:

```powershell
10, 5, 8, 1, 3 | Sort-Object -Descending
```

Example 2: Sorting Files by Name

```powershell
Get-ChildItem | Sort-Object Name
```

Example 3: Sorting Files by Size

```powershell
Get-ChildItem | Sort-Object Length
```

Example 4: Sorting by Multiple Properties

```powershell
Get-ChildItem | Sort-Object Extension, Name
```

This will first sort by file extension and then by the file name within each extension.

## Combining Filtering and Sorting

Example 1: Filter and Sort Files by Size

```powershell
Get-ChildItem | Where-Object { $_.Length -gt 1MB } | Sort-Object Length
```

 ## Using Select-Object for Advanced Filtering
 
 What is Select-Object?

The Select-Object cmdlet is used to select specific properties of an object. 
After filtering or sorting, you may want to display only a subset of properties.

Example 1: Select Specific Properties

To display only the Name and CPU properties of processes using more than 100 CPU seconds:

```powershell
Get-Process | Where-Object { $_.CPU -gt 100 } | Sort-Object CPU -Descending | Select-Object Name, CPU
```

Explanation:

Select-Object Name, CPU filters the properties to just Name and CPU.

Example 2: Select Top N Items

You can also use Select-Object to pick the top N items. For instance, to get the top 5 processes by CPU usage:

```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
```

This will display the top 5 processes sorted by CPU usage.

## Advanced Filtering and Sorting Techniques

- Using Regular Expressions in Filtering

You can use regular expressions with -match for more complex pattern matching.


```powershell
Get-ChildItem | Where-Object { $_.Name -match "^a.*\.txt$" }
```

This filters files whose names start with "a" and end with .txt.

- Using Sort-Object with Multiple Properties

You can sort by multiple properties and control the order of sorting:

```powershell
Get-ChildItem | Sort-Object @{Expression={$_.Length}; Ascending=$false}, @{Expression={$_.Name}; Ascending=$true}
```

Explanation:

This sorts by file size (descending) first, and then by name (ascending) if sizes are equal.