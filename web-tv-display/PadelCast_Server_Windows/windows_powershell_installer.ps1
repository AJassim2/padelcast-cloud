# PadelCast Server - PowerShell Installer
# Run this script as Administrator

param(
    [switch]$Uninstall
)

# Set execution policy to allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

function Write-Header {
    param([string]$Message)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Test-Python {
    try {
        $pythonVersion = python --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Python found: $pythonVersion" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "❌ Python not found in PATH" -ForegroundColor Red
        return $false
    }
    return $false
}

function Install-PadelCastServer {
    Write-Header "Installing PadelCast Server"
    
    # Check Python
    if (-not (Test-Python)) {
        Write-Host "❌ Python is required but not found!" -ForegroundColor Red
        Write-Host "Please install Python 3.8+ from https://python.org" -ForegroundColor Yellow
        Write-Host "Make sure to check 'Add Python to PATH' during installation" -ForegroundColor Yellow
        return $false
    }
    
    # Set installation directory
    $installDir = "$env:ProgramFiles\PadelCast Server"
    Write-Host "📁 Installation directory: $installDir" -ForegroundColor Cyan
    
    # Create installation directory
    if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }
    
    # Copy files
    Write-Host "📋 Copying files..." -ForegroundColor Cyan
    Copy-Item "app.py" $installDir -Force
    Copy-Item "requirements.txt" $installDir -Force
    Copy-Item "README.md" $installDir -Force
    
    # Create templates directory
    $templatesDir = "$installDir\templates"
    if (-not (Test-Path $templatesDir)) {
        New-Item -ItemType Directory -Path $templatesDir -Force | Out-Null
    }
    Copy-Item "templates\*.html" $templatesDir -Force
    
    # Create launcher script
    Write-Host "🚀 Creating launcher..." -ForegroundColor Cyan
    $launcherContent = @"
@echo off
title PadelCast Server
echo.
echo ========================================
echo    PadelCast Server - Starting...
echo ========================================
echo.
echo Web Interface: http://localhost:8080
echo TV Display: http://localhost:8080/tv/[CODE]
echo.
echo Press Ctrl+C to stop the server
echo.
cd /d "$installDir"
python app.py
echo.
echo Server stopped.
pause
"@
    $launcherContent | Out-File -FilePath "$installDir\start_server.bat" -Encoding ASCII
    
    # Create desktop shortcut
    Write-Host "🖥️ Creating desktop shortcut..." -ForegroundColor Cyan
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutContent = @"
@echo off
cd /d "$installDir"
start "" "start_server.bat"
"@
    $shortcutContent | Out-File -FilePath "$desktop\PadelCast Server.bat" -Encoding ASCII
    
    # Create start menu shortcut
    Write-Host "📋 Creating start menu shortcut..." -ForegroundColor Cyan
    $startMenu = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\PadelCast Server"
    if (-not (Test-Path $startMenu)) {
        New-Item -ItemType Directory -Path $startMenu -Force | Out-Null
    }
    Copy-Item "$desktop\PadelCast Server.bat" "$startMenu\" -Force
    
    # Create uninstaller
    Write-Host "🗑️ Creating uninstaller..." -ForegroundColor Cyan
    $uninstallContent = @"
@echo off
title PadelCast Server - Uninstaller
echo.
echo ========================================
echo    PadelCast Server - Uninstalling...
echo ========================================
echo.
set /p confirm="Are you sure you want to uninstall PadelCast Server? (y/N): "
if /i "%confirm%"=="y" (
    echo Removing files...
    rmdir /s /q "$installDir"
    del "$desktop\PadelCast Server.bat"
    rmdir /s /q "$startMenu"
    echo.
    echo Uninstallation complete!
) else (
    echo Uninstallation cancelled.
)
pause
"@
    $uninstallContent | Out-File -FilePath "$installDir\uninstall.bat" -Encoding ASCII
    
    # Install Python dependencies
    Write-Host "📦 Installing Python dependencies..." -ForegroundColor Cyan
    Set-Location $installDir
    python -m pip install --upgrade pip
    python -m pip install -r requirements.txt
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Some dependencies may not have installed correctly" -ForegroundColor Yellow
        Write-Host "You may need to run the installer as Administrator" -ForegroundColor Yellow
    }
    
    Write-Header "Installation Complete!"
    Write-Host "✅ PadelCast Server installed to: $installDir" -ForegroundColor Green
    Write-Host "✅ Desktop shortcut created: $desktop\PadelCast Server.bat" -ForegroundColor Green
    Write-Host "✅ Start menu shortcut created: $startMenu\PadelCast Server.bat" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 To start the server:" -ForegroundColor Cyan
    Write-Host "   1. Double-click 'PadelCast Server' on your desktop" -ForegroundColor White
    Write-Host "   2. Or use the start menu shortcut" -ForegroundColor White
    Write-Host ""
    Write-Host "🗑️ To uninstall:" -ForegroundColor Cyan
    Write-Host "   Run: $installDir\uninstall.bat" -ForegroundColor White
    
    return $true
}

function Uninstall-PadelCastServer {
    Write-Header "Uninstalling PadelCast Server"
    
    $installDir = "$env:ProgramFiles\PadelCast Server"
    $desktop = [Environment]::GetFolderPath("Desktop")
    $startMenu = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\PadelCast Server"
    
    if (Test-Path $installDir) {
        Write-Host "🗑️ Removing installation directory..." -ForegroundColor Cyan
        Remove-Item -Path $installDir -Recurse -Force
    }
    
    if (Test-Path "$desktop\PadelCast Server.bat") {
        Write-Host "🗑️ Removing desktop shortcut..." -ForegroundColor Cyan
        Remove-Item -Path "$desktop\PadelCast Server.bat" -Force
    }
    
    if (Test-Path $startMenu) {
        Write-Host "🗑️ Removing start menu shortcuts..." -ForegroundColor Cyan
        Remove-Item -Path $startMenu -Recurse -Force
    }
    
    Write-Host "✅ Uninstallation complete!" -ForegroundColor Green
}

# Main execution
if ($Uninstall) {
    Uninstall-PadelCastServer
} else {
    Install-PadelCastServer
}
