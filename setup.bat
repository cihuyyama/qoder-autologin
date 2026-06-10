@echo off
echo ============================================
echo   Qoder Auto-Login for 9router - Setup
echo ============================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    echo Please install Python 3.8+ from https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation.
    pause
    exit /b 1
)

echo [1/3] Installing Python packages...
pip install -r "%~dp0requirements.txt" --quiet
if errorlevel 1 (
    echo [ERROR] Failed to install packages.
    pause
    exit /b 1
)
echo       Done!

echo.
echo [2/3] Installing Playwright Chromium browser...
python -m playwright install chromium
if errorlevel 1 (
    echo [ERROR] Failed to install Playwright browser.
    pause
    exit /b 1
)
echo       Done!

echo.
echo [3/3] Checking 9router installation...
if exist "%APPDATA%\9router\db\data.sqlite" (
    echo       9router found at %APPDATA%\9router
) else (
    echo       [WARNING] 9router database not found.
    echo       Please run 9router at least once before using this tool.
)

echo.
echo ============================================
echo   Setup complete!
echo.
echo   Usage:
echo     qoder-login.bat user@gmail.com:password
echo     qoder-login.bat --batch accounts.txt
echo     qoder-login.bat --batch accounts.txt --headless
echo     qoder-login.bat --help
echo ============================================
pause
