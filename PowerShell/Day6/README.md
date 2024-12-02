# PowerShell Variables

Before diving into variables in PowerShell, it's important to recap the pipeline which alredy we dicssed earlier.

### 1. Pipeline Limitations in PowerShell

The PowerShell pipeline is a powerful feature that allows you to pass data between cmdlets, enabling you to perform operations sequentially on that data. However, while the pipeline is a powerful, but it has some limitations:

Example:

```powershell
Get-Process | Where-Object { $_.CPU -gt 100 } | Sort-Object CPU
```
    The data in PowerShell’s pipeline flows only in one direction: from left to right.

    This means that once data is passed from one cmdlet to the next, it cannot easily be sent back or manipulated earlier in the pipeline.

    So, using Pipeline in poweshell not easy to perform complex or repetitive operations without storing the data somewhere 

### 2. What is Variable?

Variables are containers used to store data that can be accessed and reused later within scripts. variables are prefixed with a dollar sign ($), which is used to declare and reference them. The primary purpose of variables is to hold various types of data such as strings, integers, arrays, and hash tables. By using variables, we can organize data efficiently and reference it throughout our scripts.

Basic Syntax:
    
    $variableName = value

Note: Variables store not just simple data types (like numbers or strings) but also objects, later, I will explin this with example.

### 3. Creating Variables:

Creating or defining variables in powershell need start with $ followed by a valid name (e.g., $name, $age). You don’t need to declare a variable type in PowerShell. You simply use the $ symbol followed by the variable name, and PowerShell automatically determines the type of the variable based on the assigned value.

```powershell
$name = "Siva"      # String

# Explicitly define a variable as a string
[string]$name = "Explicit Sting Value"
$name.GetType()  # This will return 'System.String'

$age = 30            # Integer
$isActive = $true    # Boolean
$prices = @(10, 20, 30)  # Array (using the @() syntax for array)


# Explicitly define a variable as an array
[array]$colors = @("Red", "Green", "Blue")
$colors.GetType()  # This will return 'System.Object[]'

$person = @{
    Name = "Alice"
    Age = 28
    City = "New York"
} #HashTable

# Explicitly define a variable as a DateTime
[datetime]$currentDate = Get-Date
$currentDate.GetType()  # This will return 'System.DateTime'
```

### 3. Variables with Objects

In PowerShell, variables can store not just simple data types (like numbers or strings) but also objects. When a variable contains an object, you can access all the properties and methods of that object.

For example, if you store an Services object in a variable, you gain access to all of the service properties. This can include things like:
    - Name
    - DisplayName
    - Status
    - ServcieType

```powershell
# Retrieve the service object for the Spooler service and store it in a variable
$service = Get-Service -Name Spooler

# Access properties of the service
$service.Name            # Name of the service
$service.DisplayName     # Display name of the service
$service.Status          # Current status of the service (e.g., Running, Stopped)

# You can also use the properties in a formatted output
$service | Select-Object Name, DisplayName, Status

```
### 4. Variable Scope: 
Variables in PowerShell have different scopes, and they can either be local to a function, script, or global in the session.

####  Global Variables:
Accessible throughout the entire session.
#### Local Variables: 
Accessible only within the current scope, such as inside a function.
#### Script Variables: 
Accessible only within the script where they are defined.
#### Private Variables: 
Used inside functions, but not accessible outside the function.