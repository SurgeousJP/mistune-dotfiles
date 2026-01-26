# setup.ps1
if (-not (Get-Module -ListAvailable -Name posh-git)) {
    Install-Module posh-git -Scope CurrentUser -Force
}

if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    winget install JanDeDobbeleer.OhMyPosh
}

if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module Terminal-Icons -Scope CurrentUser
}

if (-not (Get-Command rg -ErrorAction SilentlyContinue)) {
    winget install BurntSushi.ripgrep.MSVC
}
