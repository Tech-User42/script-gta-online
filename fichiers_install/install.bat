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
set ver=Version_2.0.1




for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\gta.exe" /v version ^| findstr "REG_"') do set "verinstreg=%%~b"

if "%verinstreg%" == "%ver%" (goto :already)
echo Version du script d'installation : "%ver%" 
set local1=%LOCALAPPDATA%\
if not exist "%local1%\gta" mkdir "%local1%\gta" 
path=%~dp0
echo Dossier du script localise : %path%
copy %path% %local1%gta /Y >NUL
echo Fichiers copies a cet emplacement : %local1%gta
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\gta.exe" /f /v Path /t REG_SZ /d %local1%\gta 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\gta.exe" /f /ve /t REG_SZ /d %local1%\gta\gta.bat 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\gta.exe" /f /v version /t REG_SZ /d %ver%  
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\delgta.exe" /f /ve /t REG_SZ /d %local1%\gta\Desinstaller.bat  
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\delgta.exe" /f /v Path /t REG_SZ /d %local1%\gta 
set /P start="Voulez vous faire une session publique solo maintenant O/N ?"
if "%start%" == "O" (goto :launch) 
if "%start%" == "o" (goto :launch) 
goto :end
:launch
pssuspend GTA5 /accepteula 
echo GTA Redemarre dans :
timeout 10 > NUL
pssuspend -r GTA5
:end
echo Script installer pour le lancer -^> Windows + R gta 
timeout 5 
exit
:already
echo Cette version du script est deja installe (%verinstreg%)
goto :end 
