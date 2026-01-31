
# Define the name of the component
param(
    [Parameter(Mandatory=$true)]
    [string]$Name
)

# Define the file name
$fileName = "$Name.tsx"

# Define the template content (rafce)
$template = 
@"
import React from 'react';

interface ${Name}Props {
    // define props here    
}

const ${Name}: React.FC<${Name}Props> = (props) => {
    return (
        <div>
            {/* Component implementation */}
        </div>
    );
};

export default ${Name};
"@

if (Test-Path $fileName){
    Write-Host "File $fileName already exists."
} else {
    # Create the file with the template content
    $template | Out-File -FilePath $fileName -Encoding utf8
    Write-Host "File $fileName has been created."
}