#!/usr/bin/env python3
"""
PadelCast Server Windows Installer
Creates a Windows executable and installer package
"""

import os
import sys
import subprocess
import shutil
from pathlib import Path

def create_windows_executable():
    """Create a Windows executable using PyInstaller"""
    print("🔨 Creating Windows executable...")
    
    # Install PyInstaller if not already installed
    try:
        import PyInstaller
    except ImportError:
        print("📦 Installing PyInstaller...")
        subprocess.run([sys.executable, "-m", "pip", "install", "pyinstaller"], check=True)
    
    # Create the spec file for PyInstaller
    spec_content = '''# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
    ['app.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('templates', 'templates'),
        ('static', 'static'),
        ('requirements.txt', '.'),
        ('README.md', '.'),
    ],
    hiddenimports=[
        'flask',
        'flask_socketio',
        'socketio',
        'engineio',
        'jinja2',
        'werkzeug',
        'click',
        'itsdangerous',
        'blinker',
        'markupsafe',
        'bidict',
        'simple_websocket',
        'wsproto',
        'h11',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='PadelCast_Server',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='icon.ico',
)
'''
    
    # Write the spec file
    with open('PadelCast_Server.spec', 'w') as f:
        f.write(spec_content)
    
    # Run PyInstaller
    print("🔨 Building executable...")
    subprocess.run([sys.executable, "-m", "PyInstaller", "PadelCast_Server.spec"], check=True)
    
    print("✅ Windows executable created!")

def create_windows_launcher():
    """Create a Windows batch file launcher"""
    print("🖥️ Creating Windows launcher...")
    
    launcher_content = '''@echo off
title PadelCast Server
echo.
echo ========================================
echo    PadelCast Server - Starting...
echo ========================================
echo.

REM Check if executable exists
if not exist "PadelCast_Server.exe" (
    echo ERROR: PadelCast_Server.exe not found!
    echo Please run the installer first.
    pause
    exit /b 1
)

REM Start the server
echo Starting PadelCast Server...
echo.
echo Web Interface: http://localhost:8080
echo TV Display: http://localhost:8080/tv/[CODE]
echo.
echo Press Ctrl+C to stop the server
echo.

PadelCast_Server.exe

echo.
echo Server stopped.
pause
'''
    
    with open('start_server.bat', 'w') as f:
        f.write(launcher_content)
    
    print("✅ Windows launcher created!")

def create_windows_installer():
    """Create a Windows installer using NSIS"""
    print("📦 Creating Windows installer...")
    
    # Create NSIS script
    nsis_script = '''!include "MUI2.nsh"

; General
Name "PadelCast Server"
OutFile "PadelCast_Server_Setup.exe"
InstallDir "$PROGRAMFILES\\PadelCast Server"
InstallDirRegKey HKCU "Software\\PadelCast Server" ""

; Request application privileges
RequestExecutionLevel admin

; Interface Settings
!define MUI_ABORTWARNING
!define MUI_ICON "icon.ico"
!define MUI_UNICON "icon.ico"

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Languages
!insertmacro MUI_LANGUAGE "English"

; Installer Sections
Section "PadelCast Server" SecMain
    SetOutPath "$INSTDIR"
    
    ; Copy files
    File "dist\\PadelCast_Server.exe"
    File "start_server.bat"
    File "README.md"
    File "requirements.txt"
    
    ; Create directories
    CreateDirectory "$INSTDIR\\templates"
    CreateDirectory "$INSTDIR\\static"
    
    ; Copy template files
    SetOutPath "$INSTDIR\\templates"
    File "templates\\*.html"
    
    ; Create desktop shortcut
    CreateShortCut "$DESKTOP\\PadelCast Server.lnk" "$INSTDIR\\start_server.bat" "" "$INSTDIR\\icon.ico"
    
    ; Create start menu shortcut
    CreateDirectory "$SMPROGRAMS\\PadelCast Server"
    CreateShortCut "$SMPROGRAMS\\PadelCast Server\\PadelCast Server.lnk" "$INSTDIR\\start_server.bat" "" "$INSTDIR\\icon.ico"
    CreateShortCut "$SMPROGRAMS\\PadelCast Server\\Uninstall.lnk" "$INSTDIR\\uninstall.exe" "" "$INSTDIR\\icon.ico"
    
    ; Write uninstaller
    WriteUninstaller "$INSTDIR\\uninstall.exe"
    
    ; Registry information for add/remove programs
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "DisplayName" "PadelCast Server"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "UninstallString" "$\\"$INSTDIR\\uninstall.exe$\\""
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "QuietUninstallString" "$\\"$INSTDIR\\uninstall.exe$\\" /S"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "InstallLocation" "$INSTDIR"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "DisplayIcon" "$INSTDIR\\icon.ico"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "Publisher" "PadelCast"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "DisplayVersion" "1.0"
    WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "VersionMajor" 1
    WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "VersionMinor" 0
    WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "NoModify" 1
    WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server" "NoRepair" 1
SectionEnd

; Uninstaller Section
Section "Uninstall"
    ; Remove files
    Delete "$INSTDIR\\PadelCast_Server.exe"
    Delete "$INSTDIR\\start_server.bat"
    Delete "$INSTDIR\\README.md"
    Delete "$INSTDIR\\requirements.txt"
    Delete "$INSTDIR\\icon.ico"
    
    ; Remove directories
    RMDir /r "$INSTDIR\\templates"
    RMDir /r "$INSTDIR\\static"
    
    ; Remove shortcuts
    Delete "$DESKTOP\\PadelCast Server.lnk"
    Delete "$SMPROGRAMS\\PadelCast Server\\PadelCast Server.lnk"
    Delete "$SMPROGRAMS\\PadelCast Server\\Uninstall.lnk"
    RMDir "$SMPROGRAMS\\PadelCast Server"
    
    ; Remove uninstaller
    Delete "$INSTDIR\\uninstall.exe"
    RMDir "$INSTDIR"
    
    ; Remove registry keys
    DeleteRegKey HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\PadelCast Server"
    DeleteRegKey HKCU "Software\\PadelCast Server"
SectionEnd
'''
    
    with open('installer.nsi', 'w') as f:
        f.write(nsis_script)
    
    # Create license file
    license_content = '''PadelCast Server License

This software is provided as-is for personal use.
No warranty is provided.

Copyright 2024 PadelCast
'''
    
    with open('LICENSE.txt', 'w') as f:
        f.write(license_content)
    
    print("✅ Windows installer script created!")

def create_icon():
    """Create a simple icon file (placeholder)"""
    print("🎨 Creating icon placeholder...")
    
    # Create a simple text-based icon placeholder
    icon_content = '''This is a placeholder for the icon.ico file.
In a real implementation, you would need to create a proper .ico file.
You can use online tools to convert PNG/JPG to ICO format.
'''
    
    with open('icon.ico', 'w') as f:
        f.write(icon_content)
    
    print("✅ Icon placeholder created!")

def create_windows_readme():
    """Create Windows-specific README"""
    print("📖 Creating Windows README...")
    
    readme_content = '''# PadelCast Server - Windows Installation

## Quick Start

1. **Run the installer**: Double-click `PadelCast_Server_Setup.exe`
2. **Follow the installation wizard**
3. **Start the server**: Double-click the desktop icon "PadelCast Server"
4. **Open your browser** to: http://localhost:8080
5. **Generate a code** and use it in your iPhone app

## Features

- 🎾 **Easy Installation**: One-click installer
- 🖥️ **Desktop Icon**: Start server with one click
- 🌐 **Web Interface**: Generate codes and view TV displays
- 📱 **iPhone Integration**: Sync team names and scores
- 📺 **TV Display**: Full-screen score display for TVs
- 🔄 **Real-time Updates**: Live score updates

## URLs

- **Web Interface**: http://localhost:8080
- **TV Display**: http://localhost:8080/tv/[CODE]

## Troubleshooting

- **Server won't start**: Make sure no other app is using port 8080
- **Can't connect**: Check that your iPhone and computer are on the same WiFi network
- **Firewall issues**: Allow the application through Windows Firewall

## Manual Installation (Alternative)

If the installer doesn't work:

1. **Extract** the ZIP file
2. **Open Command Prompt** as Administrator
3. **Navigate** to the extracted folder
4. **Run**: `python -m pip install -r requirements.txt`
5. **Run**: `python app.py`

## Support

For issues, check the console output when starting the server.
'''
    
    with open('README_Windows.md', 'w') as f:
        f.write(readme_content)
    
    print("✅ Windows README created!")

def main():
    """Main installation process"""
    print("🎾 PadelCast Server - Windows Package Builder")
    print("=============================================")
    
    try:
        # Create all components
        create_icon()
        create_windows_executable()
        create_windows_launcher()
        create_windows_installer()
        create_windows_readme()
        
        print("\n🎉 Windows package created successfully!")
        print("=====================================")
        print("✅ PadelCast_Server.exe - Main executable")
        print("✅ start_server.bat - Windows launcher")
        print("✅ installer.nsi - NSIS installer script")
        print("✅ README_Windows.md - Windows documentation")
        print("✅ icon.ico - Application icon")
        print("\n📦 To create the installer:")
        print("   1. Install NSIS (https://nsis.sourceforge.io/)")
        print("   2. Run: makensis installer.nsi")
        print("   3. This will create: PadelCast_Server_Setup.exe")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
