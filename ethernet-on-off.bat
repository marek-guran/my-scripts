@echo off
setlocal enabledelayedexpansion

:: Check for admin privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: If error flag set, we do not have admin.
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

:: Your script starts here

set "adapterName=Ethernet"  REM Change this to match the name of your Ethernet adapter

for /f "tokens=*" %%a in ('powershell -Command "(Get-NetAdapter | Where-Object { $_.Name -eq '%adapterName%' }).Status"') do (
    set "status=%%a"
)

if /i "%status%"=="Up" (
    echo Turning off %adapterName%...
    powershell -Command "Disable-NetAdapter -Name '%adapterName%'"
) else (
    echo Turning on %adapterName%...
    powershell -Command "Enable-NetAdapter -Name '%adapterName%'"
)

endlocal