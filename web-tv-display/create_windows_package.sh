#!/bin/bash

# PadelCast Server - Windows Package Creator
# This script creates a Windows distribution package

echo "🎾 PadelCast Server - Windows Package Creator"
echo "============================================="

# Create Windows distribution directory
WINDOWS_DIR="PadelCast_Server_Windows"
echo "📁 Creating Windows distribution directory: $WINDOWS_DIR"

# Remove existing directory if it exists
if [ -d "$WINDOWS_DIR" ]; then
    rm -rf "$WINDOWS_DIR"
fi

# Create directory structure
mkdir -p "$WINDOWS_DIR"
mkdir -p "$WINDOWS_DIR/templates"

# Copy main files
echo "📋 Copying main files..."
cp app.py "$WINDOWS_DIR/"
cp requirements.txt "$WINDOWS_DIR/"
cp README.md "$WINDOWS_DIR/"

# Copy template files
echo "📄 Copying template files..."
cp templates/*.html "$WINDOWS_DIR/templates/"

# Copy Windows-specific files
echo "🖥️ Copying Windows-specific files..."
cp windows_simple_installer.bat "$WINDOWS_DIR/"
cp README_Windows.md "$WINDOWS_DIR/"

# Create a simple icon file (placeholder)
echo "🎨 Creating icon placeholder..."
cat > "$WINDOWS_DIR/icon.ico" << 'EOF'
This is a placeholder for the icon.ico file.
In a real implementation, you would need to create a proper .ico file.
You can use online tools to convert PNG/JPG to ICO format.
EOF

# Create a simple start script for non-installer users
echo "🚀 Creating simple start script..."
cat > "$WINDOWS_DIR/start_simple.bat" << 'EOF'
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
    echo Please install Python 3.8 or later from https://python.org
    echo.
    pause
    exit /b 1
)

echo Python found:
python --version
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
EOF

# Create a ZIP file
echo "📦 Creating ZIP package..."
zip -r "PadelCast_Server_Windows.zip" "$WINDOWS_DIR"

echo ""
echo "🎉 Windows package created successfully!"
echo "====================================="
echo "✅ Distribution directory: $WINDOWS_DIR"
echo "✅ ZIP package: PadelCast_Server_Windows.zip"
echo ""
echo "📋 Package contents:"
echo "   - app.py (main server)"
echo "   - requirements.txt (dependencies)"
echo "   - templates/ (web templates)"
echo "   - windows_simple_installer.bat (installer)"
echo "   - start_simple.bat (simple launcher)"
echo "   - README_Windows.md (documentation)"
echo "   - icon.ico (placeholder icon)"
echo ""
echo "🚀 For Windows users:"
echo "   1. Extract PadelCast_Server_Windows.zip"
echo "   2. Right-click windows_simple_installer.bat"
echo "   3. Select 'Run as administrator'"
echo "   4. Follow the installation prompts"
echo "   5. Use the desktop shortcut to start the server"
echo ""
echo "📖 Documentation: README_Windows.md"
