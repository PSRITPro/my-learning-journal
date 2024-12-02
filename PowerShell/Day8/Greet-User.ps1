# Define the function with parameters
function Greet-User {
    param(
        [string]$UserName,  # Parameter to accept the user's name
        [string]$Greeting = "Hello"  # Optional parameter with a default value
    )
    
    Write-Host "$Greeting, $UserName!"  # Output a personalized greeting message
}

# Calling the function with positional parameters
Greet-User "Alice" "Hello"

# Call the function with parameters
Greet-User -UserName "Alice" -Greeting "Good morning"  # Output: "Good morning, Alice!"

# Call the function with just the required parameter
Greet-User -UserName "Bob"  # Output: "Hello, Bob!"