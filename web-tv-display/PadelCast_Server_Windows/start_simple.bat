@echo off
title PadelCast Server - Simple Start
echo.
echo ========================================
echo    PadelCast Server - Starting...
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

REM Install dependencies if needed
if not exist "venv" (
    echo Installing dependencies...
    python -m pip install --upgrade pip
    python -m pip install -r requirements.txt
)

echo.
echo Starting PadelCast Server...
echo.
echo Web Interface: http://localhost:8080
echo TV Display: http://localhost:8080/tv/[CODE]
echo.
echo Press Ctrl+C to stop the server
echo.

python app.py

echo.
echo Server stopped.
pause
