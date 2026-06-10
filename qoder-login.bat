@echo off
REM Qoder Auto-Login for 9router - Quick launcher
REM Usage: qoder-login.bat [options] [email:password ...]
REM Run qoder-login.bat --help for full options

python "%~dp0qoder_autologin.py" %*
if errorlevel 1 pause
