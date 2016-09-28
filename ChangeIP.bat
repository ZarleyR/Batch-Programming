@echo off
setLocal enableDelayedExpansion
set c=0
set "choices="
echo.
echo.
echo *******************************************************************************
echo -------------------------------------------------------------------------------
echo ******************* Federal System Technologist IP Changer ********************
echo -------------------------------------------------------------------------------
echo *******************************************************************************
echo.
echo   Select the Interface to modify:
echo.
for /f "skip=2 tokens=3*" %%A in ('netsh interface show interface') do (
    set /a c+=1
    set int!c!=%%B
    set choices=!choices!!c!
    echo [!c!] %%B
)

choice /c !choices! /m "Select Interface: "
set interface=!int%errorlevel%!
echo.
cls
echo.
echo.
echo   Current IP Settings:
echo.
echo *******************************************************************************
echo ------------------------------------------------------------------------------- 
netsh int ip show config "%interface%"
echo -------------------------------------------------------------------------------
echo *******************************************************************************
echo.
echo  Now choose from the following selection:
echo.
echo [1] Static IP
echo [2] Dynamic IP (DHCP) 
echo.
:choice 
SET /P C="Select Mode: [1,2]?" 
for %%? in (1) do if /I "%C%"=="%%?" goto 1 
for %%? in (2) do if /I "%C%"=="%%?" goto 2 
goto choice 
:1
@echo off
cls
echo.
echo  Please Enter Static IP Address Information:
echo.
echo Type Static IP Address   Ex.10.X.XX.XXX 
set /p IP_Addr=
echo.
echo Type Subnet Mask         Ex. 255.255.255.0 
set /p Sub_Mask=
echo.
echo Type Default Gateway     Ex. 10.X.XX.254 
set /p D_Gate=
echo.
echo Type Primary DNS         Ex. 10.X.X.161 
set /p P_DNS=
echo.
echo  Setting Static IP Information
netsh int ip set address "%interface%" static %IP_Addr% %Sub_Mask% %D_Gate% 1
netsh int ip set dns "%interface%" static %P_DNS%
echo.
echo *******************************************************************************
echo -------------------------------------------------------------------------------
echo  Here are the new settings for %computername%: 
netsh int ip show config "%interface%"
echo -------------------------------------------------------------------------------
echo *******************************************************************************
pause 
goto end

:2
@echo off
cls
echo.
echo.
echo  Resetting IP Address and Subnet Mask For DHCP
netsh int ip set dns "%interface%" static 10.10.10.10
netsh interface ip set address "%interface%" dhcp
netsh interface ip set dns "%interface%" dhcp
echo *******************************************************************************
echo -------------------------------------------------------------------------------
echo  Here are the new settings for %computername%: 
netsh int ip show config "%interface%"
echo -------------------------------------------------------------------------------
echo *******************************************************************************
pause
goto end 
:end
