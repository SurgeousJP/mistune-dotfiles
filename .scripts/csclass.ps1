param(
    [Parameter(Mandatory=$true)]
    [string]$ClassName
)

# Construct file name
$fileName = "$ClassName.cs"

# Build namespace: project root folder name + subfolders (relative path)
$fullPath = (Get-Location).Path
$projectRoot = Split-Path -Path $fullPath -Parent

# Determine namespace by finding common root and converting backslashes to dots
$relativePath = $fullPath.Replace("$projectRoot\", "")
$namespace = $relativePath -replace '[^A-Za-z0-9\\]', '' -replace '\\', '.'

# If namespace becomes empty or invalid, fallback to folder name
if ([string]::IsNullOrWhiteSpace($namespace)) {
    $namespace = Split-Path -Leaf (Get-Location)
}

# Sanitize starting digits
if ($namespace -match '^[0-9]') {
    $namespace = '_' + $namespace
}

# Class template
$content = @"
namespace $namespace
{
    public class $ClassName
    {
        public $ClassName()
        {
        }
    }
}
"@

# Write file
Set-Content -Path $fileName -Value $content -Encoding utf8

Write-Host "Created: $fileName"
Write-Host "Namespace: $namespace"
