# PadelCast Server - Windows Installation Guide

## 🎾 Quick Start

1. **Download** the PadelCast Server files
2. **Run** `windows_simple_installer.bat` as Administrator
3. **Double-click** the "PadelCast Server" icon on your desktop
4. **Open your browser** to: http://localhost:8080
5. **Generate a code** and use it in your iPhone app

## 📋 Requirements

- **Windows 10/11** (64-bit recommended)
- **Python 3.13 or later** (https://python.org)
- **Internet connection** for initial setup

## 🚀 Installation Options

### Option 1: Simple Installer (Recommended)
1. **Right-click** `windows_simple_installer.bat`
2. **Select "Run as administrator"**
3. **Follow the installation prompts**
4. **Use the desktop shortcut** to start the server

### Option 2: Manual Installation
1. **Open Command Prompt** as Administrator
2. **Navigate** to the PadelCast Server folder
3. **Run**: `python -m pip install -r requirements.txt`
4. **Run**: `python app.py`

## 🖥️ Features

- ✅ **Easy Installation**: One-click installer
- 🖥️ **Desktop Icon**: Start server with one click
- 🌐 **Web Interface**: Generate codes and view TV displays
- 📱 **iPhone Integration**: Sync team names and scores
- 📺 **TV Display**: Full-screen score display for TVs
- 🔄 **Real-time Updates**: Live score updates
- 🛠️ **Automatic Uninstaller**: Clean removal

## 🌐 URLs

- **Web Interface**: http://localhost:8080
- **TV Display**: http://localhost:8080/tv/[CODE]

## 📱 How to Use

### 1. Start the Server
- **Double-click** "PadelCast Server" on your desktop
- **Wait** for the server to start (you'll see a console window)
- **Keep the console window open** while using the server

### 2. Generate a Code
- **Open your browser** to http://localhost:8080
- **Enter team names** (e.g., "Team A" vs "Team B")
- **Click "Generate Code"**
- **Copy the 6-character code** (e.g., "ABC123")

### 3. Use with iPhone App
- **Open your PadelCast iPhone app**
- **Tap "Enter TV Code"**
- **Enter the 6-character code**
- **Team names will sync automatically**
- **Start scoring points**

### 4. Display on TV
- **Open your TV's web browser**
- **Go to**: http://localhost:8080/tv/[CODE]
- **Replace [CODE]** with your actual code
- **Scores will update in real-time**

## 🔧 Troubleshooting

### Server Won't Start
- **Check if port 8080 is in use**:
  - Open Command Prompt
  - Run: `netstat -an | findstr :8080`
  - If port is in use, close other applications
- **Run as Administrator**:
  - Right-click the desktop shortcut
  - Select "Run as administrator"

### Can't Connect from iPhone
- **Check WiFi network**: Both devices must be on same network
- **Check firewall**: Allow Python through Windows Firewall
- **Use IP address**: Instead of localhost, use your computer's IP address

### Python Not Found
- **Install Python 3.13**: Download from https://python.org
- **Add to PATH**: During installation, check "Add Python to PATH"
- **Restart computer** after Python installation

### Dependencies Installation Failed
- **Run installer as Administrator**:
  - Right-click `windows_simple_installer.bat`
  - Select "Run as administrator"
- **Check internet connection**
- **Try manual installation**:
  ```cmd
  python -m pip install --upgrade pip
  python -m pip install flask flask-socketio python-socketio python-engineio
  ```

## 🗑️ Uninstallation

### Using Uninstaller
1. **Navigate** to: `C:\Program Files\PadelCast Server`
2. **Run**: `uninstall.bat`
3. **Confirm** the uninstallation

### Manual Uninstallation
1. **Delete** the installation folder: `C:\Program Files\PadelCast Server`
2. **Delete** desktop shortcut: `%USERPROFILE%\Desktop\PadelCast Server.bat`
3. **Delete** start menu folder: `%APPDATA%\Microsoft\Windows\Start Menu\Programs\PadelCast Server`

## 📁 File Structure

After installation:
```
C:\Program Files\PadelCast Server\
├── app.py                 # Main server file
├── requirements.txt       # Python dependencies
├── start_server.bat      # Server launcher
├── uninstall.bat         # Uninstaller
├── README.md             # Documentation
└── templates\            # Web templates
    ├── index.html
    ├── tv_display.html
    └── error.html
```

## 🔒 Security Notes

- **Firewall**: Windows may ask to allow the application through firewall
- **Antivirus**: Some antivirus software may flag Python applications
- **Network**: Only accessible on your local network by default

## 📞 Support

### Common Issues
1. **"Python not found"**: Install Python 3.13 and add to PATH
2. **"Port already in use"**: Close other applications using port 8080
3. **"Permission denied"**: Run as Administrator
4. **"Module not found"**: Re-run the installer as Administrator

### Getting Help
- **Check console output** for error messages
- **Verify Python installation**: `python --version`
- **Check network connectivity**: `ping localhost`
- **Test web interface**: Open http://localhost:8080 in browser

## 🎯 Tips for Best Experience

1. **Keep the console window open** while using the server
2. **Use a modern web browser** (Chrome, Firefox, Edge)
3. **Ensure stable WiFi connection** between devices
4. **Restart the server** if you experience connection issues
5. **Use the desktop shortcut** for easy access

---

**PadelCast Server v1.0** - Windows Edition
