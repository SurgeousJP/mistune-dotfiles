param(
    [Parameter(Mandatory=$true)]
    [string]$Name
)

# Create file name
$fileName = "$Name.ts"

# Check if file already exists
if (Test-Path $fileName) {
    Write-Host "Error: File '$fileName' already exists!" -ForegroundColor Red
    exit
}

# Template content
$template = @"
export interface $Name {
    
}
"@

# Write file
Set-Content -Path $fileName -Value $template -Encoding UTF8

Write-Host "Created file: $fileName with interface $Name" -ForegroundColor Green
