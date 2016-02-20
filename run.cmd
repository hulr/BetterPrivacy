@echo off
ver | find "Version 10." > nul
if %ERRORLEVEL% == 0 (
powershell.exe -executionpolicy bypass -file BetterPrivacy.ps1
) else (
echo your operating system is not supported
echo please take a look at the system requirements stated in the README.md file
echo.
pause
exit
)