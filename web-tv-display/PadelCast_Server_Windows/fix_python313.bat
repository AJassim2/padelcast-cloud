@echo off
title PadelCast Server - Python 3.13 Fix
echo.
echo ========================================
echo    PadelCast Server - Python 3.13 Fix
echo ========================================
echo.

echo This script will fix Python 3.13 compatibility issues.
echo.
echo Current Python version:
python --version
echo.

echo Step 1: Uninstalling incompatible packages...
pip uninstall flask flask-socketio python-socketio python-engineio -y
echo.

echo Step 2: Installing compatible versions...
pip install Flask==3.0.2
pip install Flask-SocketIO==5.5.1
pip install python-socketio==5.10.1
pip install python-engineio==4.8.1
echo.

echo Step 3: Testing installation...
python -c "import flask; import flask_socketio; print('✅ All packages installed successfully')"
echo.

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo    ✅ Fix completed successfully!
    echo ========================================
    echo.
    echo You can now run the PadelCast Server.
    echo.
) else (
    echo.
    echo ========================================
    echo    ❌ Fix failed. Please try manual steps.
    echo ========================================
    echo.
    echo See WINDOWS_PYTHON313_TROUBLESHOOTING.md for manual steps.
    echo.
)

echo Press any key to continue...
pause >nul
