@echo off
set local1=%LOCALAPPDATA%\Temp\ 
copy %LOCALAPPDATA%\gta\uninstall.bat %local1% /Y
call %LOCALAPPDATA%\gta\uninstall.bat
