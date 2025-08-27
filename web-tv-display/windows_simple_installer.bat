@echo off
title PadelCast Server - Windows Installer
echo.
echo ========================================
echo    PadelCast Server - Windows Setup
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed!
    echo Please install Python 3.13 from https://python.org
    echo.
    pause
    exit /b 1
)

REM Check Python version
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo Python found: %PYTHON_VERSION%

REM Check if Python version is 3.13 or higher
for /f "tokens=2 delims=." %%a in ("%PYTHON_VERSION%") do set PYTHON_MAJOR=%%a
for /f "tokens=3 delims=." %%b in ("%PYTHON_VERSION%") do set PYTHON_MINOR=%%b

if %PYTHON_MAJOR% LSS 3 (
    echo ERROR: Python 3.13 or higher is required!
    echo Current version: %PYTHON_VERSION%
    echo Please upgrade to Python 3.13 from https://python.org
    echo.
    pause
    exit /b 1
)

if %PYTHON_MAJOR% EQU 3 (
    if %PYTHON_MINOR% LSS 13 (
        echo ERROR: Python 3.13 or higher is required!
        echo Current version: %PYTHON_VERSION%
        echo Please upgrade to Python 3.13 from https://python.org
        echo.
        pause
        exit /b 1
    )
)

echo.

REM Create installation directory
set INSTALL_DIR=%PROGRAMFILES%\PadelCast Server
echo Creating installation directory: %INSTALL_DIR%
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

REM Copy files to installation directory
echo Copying files...
copy "app.py" "%INSTALL_DIR%\"
copy "requirements.txt" "%INSTALL_DIR%\"
copy "README.md" "%INSTALL_DIR%\"

REM Create templates directory
if not exist "%INSTALL_DIR%\templates" mkdir "%INSTALL_DIR%\templates"
copy "templates\*.html" "%INSTALL_DIR%\templates\"

REM Create static directory if it exists
if exist "static" (
    if not exist "%INSTALL_DIR%\static" mkdir "%INSTALL_DIR%\static"
    copy "static\*" "%INSTALL_DIR%\static\"
)

REM Create launcher batch file
echo Creating launcher...
(
echo @echo off
echo title PadelCast Server
echo echo.
echo echo ========================================
echo echo    PadelCast Server - Starting...
echo echo ========================================
echo echo.
echo echo Web Interface: http://localhost:8080
echo echo TV Display: http://localhost:8080/tv/^[CODE^]
echo echo.
echo echo Press Ctrl+C to stop the server
echo echo.
echo cd /d "%INSTALL_DIR%"
echo python app.py
echo echo.
echo echo Server stopped.
echo pause
) > "%INSTALL_DIR%\start_server.bat"

REM Create desktop shortcut
echo Creating desktop shortcut...
set DESKTOP=%USERPROFILE%\Desktop
(
echo @echo off
echo cd /d "%INSTALL_DIR%"
echo start "" "start_server.bat"
) > "%DESKTOP%\PadelCast Server.bat"

REM Create start menu shortcut
echo Creating start menu shortcut...
set START_MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs\PadelCast Server
if not exist "%START_MENU%" mkdir "%START_MENU%"

(
echo @echo off
echo cd /d "%INSTALL_DIR%"
echo start "" "start_server.bat"
) > "%START_MENU%\PadelCast Server.bat"

REM Create uninstaller
echo Creating uninstaller...
(
echo @echo off
echo title PadelCast Server - Uninstaller
echo echo.
echo echo ========================================
echo echo    PadelCast Server - Uninstalling...
echo echo ========================================
echo echo.
echo set /p confirm="Are you sure you want to uninstall PadelCast Server? (y/N): "
echo if /i "%%confirm%%"=="y" (
echo     echo Removing files...
echo     rmdir /s /q "%INSTALL_DIR%"
echo     del "%DESKTOP%\PadelCast Server.bat"
echo     rmdir /s /q "%START_MENU%"
echo     echo.
echo     echo Uninstallation complete!
echo ) else (
echo     echo Uninstallation cancelled.
echo )
echo pause
) > "%INSTALL_DIR%\uninstall.bat"

REM Install Python dependencies
echo Installing Python dependencies...
cd /d "%INSTALL_DIR%"
python -m pip install --upgrade pip
python -m pip install -r requirements_windows_python313.txt

if errorlevel 1 (
    echo.
    echo WARNING: Failed to install some dependencies.
    echo You may need to run the installer as Administrator.
    echo.
    pause
)

echo.
echo ========================================
echo    Installation Complete!
echo ========================================
echo.
echo PadelCast Server has been installed to:
echo %INSTALL_DIR%
echo.
echo Desktop shortcut created: %DESKTOP%\PadelCast Server.bat
echo Start menu shortcut created: %START_MENU%\PadelCast Server.bat
echo.
echo To start the server:
echo 1. Double-click "PadelCast Server" on your desktop
echo 2. Or use the start menu shortcut
echo.
echo To uninstall:
echo Run: %INSTALL_DIR%\uninstall.bat
echo.
pause
