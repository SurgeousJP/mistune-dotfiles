param(
    [Parameter(Mandatory=$true)]
    [string]$Name
)

# Function to validate first char is uppercase
function Validate-UppercaseFirstChar {
    param([string]$InputName)

    while (-not ($InputName.Substring(0,1) -cmatch '[A-Z]')) {
        Write-Host "Error: First character must be uppercase. Please enter a new name:" -ForegroundColor Red
        $InputName = Read-Host "Name"
    }
    return $InputName
}

# Validate Name
$Name = Validate-UppercaseFirstChar $Name

# File name (lowercase slice name convention)
$fileName = "$Name.ts"

# Check if file already exists
if (Test-Path $fileName) {
    Write-Host "Error: File '$fileName' already exists!" -ForegroundColor Red
    exit
}

# Lowercase for slice variable
$lowerName = $Name.Substring(0,1).ToLower() + $Name.Substring(1)

# Template content
$template = @"
import { createSlice } from "@reduxjs/toolkit";

const initialState: ${Name}State = {
}

const ${lowerName}Slice = createSlice({
    name: "$lowerName",
    initialState,
    reducers: {
        update${Name}Data: (state: ${Name}State, action) => {
            state.data = action.payload;
        }
    }
});

export const { update${Name}Data } = ${lowerName}Slice.actions;
export default ${lowerName}Slice.reducer;
"@

# Write the file
Set-Content -Path $fileName -Value $template -Encoding UTF8

Write-Host "Created Redux slice file: $fileName" -ForegroundColor Green
