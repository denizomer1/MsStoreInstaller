@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

echo uninstalling Microsoft Store...

powershell.exe -Command "& {Get-AppxPackage *Microsoft.WindowsStore* | Remove-AppxPackage}"

powershell.exe -Command "& {clear}"

powershell.exe -Command "& {Get-AppxPackage *Microsoft.StorePurchaseApp* | Remove-AppxPackage}"

powershell.exe -Command "& {clear}"

powershell.exe -Command "& {Get-AppxPackage *Microsoft.XboxIdentityProvider* | Remove-AppxPackage}"

powershell.exe -Command "& {clear}"

powershell.exe -Command "& {Get-AppxPackage *Microsoft.GamingServices* | Remove-AppxPackage}"

powershell.exe -Command "& {clear}"
set /p "id=Microsoft Store uninstalled press enter key to exit"