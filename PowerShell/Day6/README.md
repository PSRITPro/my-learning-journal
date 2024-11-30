
# PowerShell Variables

In PowerShell, variables are used to store data, which can then be reused throughout the script or session. Variables in PowerShell are prefixed with the $ symbol, followed by the variable name.

### 1. Declaring Variables:
You don’t need to declare a variable type in PowerShell. You simply use the $ symbol followed by the variable name, and PowerShell automatically determines the type of the variable based on the assigned value.

```powershell
$name = "Siva"      # String
$age = 30            # Integer
$isActive = $true    # Boolean
$prices = @(10, 20, 30)  # Array (using the @() syntax for array)
```

### 2. Variable Types: 
PowerShell is dynamically typed, meaning variables do not need to be explicitly defined with a data type. However, you can specify types if needed.

Examples:

String: "Hello"

Integer: 5

Boolean: $true or $false

Array: @(1, 2, 3)

Hash Table (Object): @{key="value"}

### 3. Variable Scope: 
Variables in PowerShell have different scopes, and they can either be local to a function, script, or global in the session.

####  Global Variables:
Accessible throughout the entire session.
#### Local Variables: 
Accessible only within the current scope, such as inside a function.
#### Script Variables: 
Accessible only within the script where they are defined.
#### Private Variables: 
Used inside functions, but not accessible outside the function.