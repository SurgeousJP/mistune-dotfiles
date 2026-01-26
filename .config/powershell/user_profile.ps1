# Add to $PROFILE in powershell
# Modules
Import-Module posh-git
Import-Module Terminal-Icons

# Oh My Posh
$omp_config = "$HOME\.config\oh-my-posh\mistune.omp.json" # add file to correct path in windows
oh-my-posh init pwsh --config $omp_config | Invoke-Expression

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key Tab -Function Complete

# Aliases
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# Utilities
function which ($command) {
    Get-Command $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
