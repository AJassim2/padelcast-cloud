# 🔧 Windows Python 3.13 Troubleshooting Guide

## 🚨 Common Error: `AttributeError: type object 'Server' has no attribute 'reason'`

### What This Error Means
This error occurs when there's a version compatibility issue between Flask-SocketIO and python-socketio packages with Python 3.13.

### Quick Fix
1. **Uninstall current packages**:
   ```cmd
   pip uninstall flask-socketio python-socketio python-engineio
   ```

2. **Install compatible versions**:
   ```cmd
   pip install Flask==3.0.2
   pip install Flask-SocketIO==5.5.1
   pip install python-socketio==5.10.1
   pip install python-engineio==4.8.1
   ```

3. **Or use the Windows-specific requirements**:
   ```cmd
   pip install -r requirements_windows_python313.txt
   ```

## 🔄 Complete Reinstallation Process

### Step 1: Clean Environment
```cmd
# Remove existing packages
pip uninstall flask flask-socketio python-socketio python-engineio -y

# Clear pip cache
pip cache purge
```

### Step 2: Install Compatible Versions
```cmd
# Install specific versions known to work with Python 3.13
pip install Flask==3.0.2
pip install Flask-SocketIO==5.5.1
pip install python-socketio==5.10.1
pip install python-engineio==4.8.1
```

### Step 3: Verify Installation
```cmd
# Test imports
python -c "import flask; import flask_socketio; print('✅ All packages installed successfully')"
```

## 🛠️ Alternative Solutions

### Solution 1: Use Virtual Environment
```cmd
# Create new virtual environment
python -m venv padelcast_env

# Activate environment
padelcast_env\Scripts\activate

# Install packages in clean environment
pip install -r requirements_windows_python313.txt
```

### Solution 2: Manual Package Installation
```cmd
# Install packages one by one with specific versions
pip install Flask==3.0.2
pip install Werkzeug>=3.0.0
pip install Jinja2>=3.1.2
pip install python-engineio==4.8.1
pip install python-socketio==5.10.1
pip install Flask-SocketIO==5.5.1
```

### Solution 3: Use Conda (if available)
```cmd
# Create conda environment
conda create -n padelcast python=3.13

# Activate environment
conda activate padelcast

# Install packages
pip install -r requirements_windows_python313.txt
```

## 🔍 Version Compatibility Matrix

| Package | Python 3.13 Compatible Version |
|---------|--------------------------------|
| Flask | 3.0.2 |
| Flask-SocketIO | 5.5.1 |
| python-socketio | 5.10.1 |
| python-engineio | 4.8.1 |
| Werkzeug | >=3.0.0 |

## 🚨 Other Common Errors

### Error: `ModuleNotFoundError: No module named 'flask'`
**Solution**: Install Flask first
```cmd
pip install Flask==3.0.2
```

### Error: `ImportError: cannot import name 'Server' from 'socketio'`
**Solution**: Install compatible python-socketio version
```cmd
pip install python-socketio==5.10.1
```

### Error: `AttributeError: 'NoneType' object has no attribute 'get'`
**Solution**: Update Werkzeug
```cmd
pip install Werkzeug>=3.0.0
```

## 📋 Verification Commands

### Check Installed Versions
```cmd
pip list | findstr -i flask
pip list | findstr -i socketio
pip list | findstr -i engineio
```

### Test Server Startup
```cmd
python -c "
from flask import Flask
from flask_socketio import SocketIO
app = Flask(__name__)
socketio = SocketIO(app)
print('✅ Server components initialized successfully')
"
```

## 🔧 Advanced Troubleshooting

### Check Python Version
```cmd
python --version
# Should show: Python 3.13.x
```

### Check pip Version
```cmd
pip --version
# Should be recent version
```

### Update pip
```cmd
python -m pip install --upgrade pip
```

### Clear All Caches
```cmd
pip cache purge
pip uninstall flask flask-socketio python-socketio python-engineio -y
```

## 📞 Getting Help

### If Problems Persist
1. **Check Python version**: `python --version`
2. **Check pip version**: `pip --version`
3. **List installed packages**: `pip list`
4. **Try virtual environment**: Create fresh environment
5. **Contact support**: Provide error messages and versions

### Debug Information
When reporting issues, include:
- Python version: `python --version`
- pip version: `pip --version`
- Installed packages: `pip list`
- Full error traceback
- Operating system version

## 🎯 Quick Fix Script

Create a file called `fix_python313.bat`:
```batch
@echo off
echo Fixing Python 3.13 compatibility issues...
echo.

echo Uninstalling old packages...
pip uninstall flask flask-socketio python-socketio python-engineio -y

echo Installing compatible versions...
pip install Flask==3.0.2
pip install Flask-SocketIO==5.5.1
pip install python-socketio==5.10.1
pip install python-engineio==4.8.1

echo.
echo Testing installation...
python -c "import flask; import flask_socketio; print('✅ Fixed successfully!')"

echo.
echo Done! Try running the server again.
pause
```

---

**PadelCast Server v1.1** - Windows Python 3.13 Troubleshooting  
*Resolving compatibility issues for Windows users*
