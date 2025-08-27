# 🎾 PadelCast Server - Windows Installation Guide

## 📦 What You Get

The Windows package includes everything needed to run the PadelCast web server:

### 📁 Package Contents
- **`app.py`** - Main web server application
- **`requirements.txt`** - Python dependencies
- **`templates/`** - Web interface templates
- **`windows_simple_installer.bat`** - Easy batch file installer
- **`windows_powershell_installer.ps1`** - PowerShell installer (advanced)
- **`start_simple.bat`** - Simple launcher (no installation)
- **`README_Windows.md`** - Detailed Windows documentation
- **`icon.ico`** - Application icon placeholder

## 🚀 Quick Installation (Recommended)

### Step 1: Download and Extract
1. **Download** `PadelCast_Server_Windows_Complete.zip`
2. **Extract** to a folder on your computer
3. **Open** the extracted folder

### Step 2: Install
1. **Right-click** `windows_simple_installer.bat`
2. **Select "Run as administrator"**
3. **Wait** for installation to complete
4. **Click OK** when finished

### Step 3: Start the Server
1. **Double-click** "PadelCast Server" on your desktop
2. **Wait** for the server to start (console window opens)
3. **Keep the console window open** while using the server

### Step 4: Use the Web Interface
1. **Open your browser** to: http://localhost:8080
2. **Enter team names** and generate a code
3. **Use that code** in your iPhone app

## 🔧 Alternative Installation Methods

### Method 1: PowerShell Installer (Advanced Users)
```powershell
# Open PowerShell as Administrator
# Navigate to the PadelCast folder
# Run:
.\windows_powershell_installer.ps1
```

### Method 2: Manual Installation
```cmd
# Open Command Prompt as Administrator
# Navigate to the PadelCast folder
# Run:
python -m pip install -r requirements.txt
python app.py
```

### Method 3: Simple Launcher (No Installation)
1. **Double-click** `start_simple.bat`
2. **Follow the prompts** to install dependencies
3. **Server starts automatically**

## 📱 How to Use with iPhone App

### 1. Generate a Code
- **Open browser** to http://localhost:8080
- **Enter team names** (e.g., "Team A" vs "Team B")
- **Click "Generate Code"**
- **Copy the 6-character code** (e.g., "ABC123")

### 2. Enter Code in iPhone App
- **Open your PadelCast iPhone app**
- **Tap "Enter TV Code"**
- **Enter the 6-character code**
- **Team names sync automatically**

### 3. Display on TV
- **Open TV's web browser**
- **Go to**: http://localhost:8080/tv/[CODE]
- **Replace [CODE]** with your actual code
- **Scores update in real-time**

## 🖥️ Features

- ✅ **One-Click Installation** - No technical knowledge required
- 🖥️ **Desktop Icon** - Start server with one click
- 🌐 **Web Interface** - Generate codes and view TV displays
- 📱 **iPhone Integration** - Sync team names and scores
- 📺 **TV Display** - Full-screen score display for TVs
- 🔄 **Real-time Updates** - Live score updates
- 🛠️ **Automatic Uninstaller** - Clean removal

## 🔧 Troubleshooting

### Common Issues

#### "Python not found"
- **Solution**: Install Python from https://python.org
- **Important**: Check "Add Python to PATH" during installation

#### "Port 8080 already in use"
- **Solution**: Close other applications using port 8080
- **Check**: Open Command Prompt and run: `netstat -an | findstr :8080`

#### "Permission denied"
- **Solution**: Run installer as Administrator
- **Right-click** the installer → "Run as administrator"

#### "Module not found"
- **Solution**: Re-run installer as Administrator
- **Alternative**: Run `python -m pip install flask flask-socketio`

#### Can't connect from iPhone
- **Check**: Both devices on same WiFi network
- **Check**: Windows Firewall allows Python
- **Try**: Use computer's IP address instead of localhost

### Getting Help

1. **Check console output** for error messages
2. **Verify Python**: `python --version`
3. **Test web interface**: Open http://localhost:8080
4. **Check network**: `ping localhost`

## 🗑️ Uninstallation

### Using Uninstaller
1. **Navigate** to: `C:\Program Files\PadelCast Server`
2. **Run**: `uninstall.bat`
3. **Confirm** the uninstallation

### Manual Uninstallation
1. **Delete** folder: `C:\Program Files\PadelCast Server`
2. **Delete** desktop shortcut: `%USERPROFILE%\Desktop\PadelCast Server.bat`
3. **Delete** start menu: `%APPDATA%\Microsoft\Windows\Start Menu\Programs\PadelCast Server`

## 📁 File Locations

After installation:
```
C:\Program Files\PadelCast Server\
├── app.py                 # Main server
├── requirements.txt       # Dependencies
├── start_server.bat      # Launcher
├── uninstall.bat         # Uninstaller
├── README.md             # Documentation
└── templates\            # Web templates
    ├── index.html
    ├── tv_display.html
    └── error.html
```

## 🔒 Security Notes

- **Firewall**: Windows may ask to allow the application
- **Antivirus**: Some antivirus may flag Python applications
- **Network**: Only accessible on local network by default
- **Administrator**: Installer requires admin privileges

## 🎯 Tips for Best Experience

1. **Keep console window open** while using server
2. **Use modern browser** (Chrome, Firefox, Edge)
3. **Ensure stable WiFi** between devices
4. **Restart server** if connection issues occur
5. **Use desktop shortcut** for easy access

## 📞 Support

### System Requirements
- **Windows 10/11** (64-bit recommended)
- **Python 3.8+** (https://python.org)
- **Internet connection** for initial setup

### Quick Commands
```cmd
# Check Python version
python --version

# Check if port 8080 is in use
netstat -an | findstr :8080

# Test web interface
curl http://localhost:8080

# Check Python modules
python -c "import flask, flask_socketio; print('OK')"
```

---

**PadelCast Server v1.0** - Windows Edition  
*Easy web server for padel match scoring and TV display*
