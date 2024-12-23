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
setlocal enabledelayedexpansion

echo installing Microsoft Store...

for %%X in (packages\Microsoft.Dependencies*.appx) do (
    powershell -ExecutionPolicy ByPass "& {add-appxpackage %%X}"
)

powershell.exe -Command "& {clear}"

for %%X in (packages\Microsoft.Apps*.msix) do (
    powershell -ExecutionPolicy ByPass "& {add-appxpackage %%X}"
)

powershell.exe -Command "& {clear}"

for %%X in (packages\Microsoft.StorePurchaseApp.AppxBundle) do (
    powershell -ExecutionPolicy ByPass "& {add-appxpackage %%X}"
)

powershell.exe -Command "& {clear}"

for %%X in (packages\Microsoft.Apps*.appx) do (
    powershell -ExecutionPolicy ByPass "& {add-appxpackage %%X}"
)

powershell.exe -Command "& {clear}"
set /p "id=Microsoft Store installed press enter key to exit"