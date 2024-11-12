# Use the current user's credentials
$Credential = New-Object System.Management.Automation.PSCredential ($env:UserName, (New-Object System.Security.SecureString))

# Build the base64 encoded authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $env:USERNAME, $Credential.GetNetworkCredential().Password)))

# Set the headers
$headers = @{
    "Authorization" = "Basic $base64AuthInfo"
    "Accept"        = "application/json"
    "Content-Type"  = "application/json"
}

# Specify the endpoint URI
$uri = "https://your_instance.service-now.com/api/now/table/your_table"

# Specify the HTTP method
$method = "GET"

# Send the HTTP request
$response = Invoke-RestMethod -Headers $headers -Method $method -Uri $uri

# Print the response
$response
