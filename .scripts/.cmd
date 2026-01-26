@echo off
for %%I in ("%CD%") do set "DIRNAME=%%~nxI"

powershell -NoExit -NoLogo -Command ^
  "$host.UI.RawUI.WindowTitle = '%DIRNAME%'; Set-Location '%CD%'"

