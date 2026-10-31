@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0atlas-skills.ps1" %*
exit /b %ERRORLEVEL%
