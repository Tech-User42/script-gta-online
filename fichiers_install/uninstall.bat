@echo off

:: BatchGotAdmin
:-------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Attente de l'autorisation d'execution...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
:--------------------------------------
set /P confirm="Voulez vous vraiment supprimer le script de session publique solo O/N ?"
if "%confirm%" == "O" (goto :del) 
if "%confirm%" == "o" (goto :del)
goto :exit
:del
cd %LOCALAPPDATA%
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\gta.exe"
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\delgta.exe"
rmdir gta /S /Q
echo Fermeture du programme de desinstalation.
timeout 10
exit
goto :exit
:exit
echo Fermeture du programme de desinstalation.
timeout 10
exit