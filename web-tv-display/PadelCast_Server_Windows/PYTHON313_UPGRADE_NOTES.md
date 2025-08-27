# 🐍 Python 3.13 Upgrade for Windows

## 📋 What Changed

The PadelCast Server Windows package has been upgraded to require **Python 3.13** for better performance, security, and compatibility.

## 🔄 Upgrade Details

### Previous Requirements
- Python 3.8 or later

### New Requirements
- **Python 3.13 or later**

## 🚀 Benefits of Python 3.13

### Performance Improvements
- **Faster startup times** - Up to 10-60% faster
- **Better memory usage** - More efficient memory management
- **Improved error handling** - Better error messages and debugging

### Security Enhancements
- **Latest security patches** - Protection against known vulnerabilities
- **Enhanced SSL/TLS** - Better encryption for web communications
- **Updated dependencies** - All packages use latest secure versions

### Compatibility
- **Modern web standards** - Better support for current web technologies
- **Enhanced Socket.IO** - Improved real-time communication
- **Better Windows integration** - Native Windows 10/11 support

## 📦 Updated Package

### New Package Name
- `PadelCast_Server_Windows_Python313.zip`

### What's Updated
- ✅ **Version checking** - Installers now verify Python 3.13+
- ✅ **Error messages** - Clear instructions for Python 3.13 requirement
- ✅ **Documentation** - All guides updated for Python 3.13
- ✅ **Dependencies** - Updated to latest compatible versions
- ✅ **Installation scripts** - Enhanced version validation

## 🔧 Installation Changes

### Automatic Version Checking
All installers now automatically check for Python 3.13+ and provide clear error messages if an older version is detected.

### Enhanced Error Messages
```
ERROR: Python 3.13 or higher is required!
Current version: Python 3.8.10
Please upgrade to Python 3.13 from https://python.org
```

### PowerShell Support
The PowerShell installer now includes intelligent version checking with colored output.

## 📥 How to Upgrade

### For New Users
1. **Download** `PadelCast_Server_Windows_Python313.zip`
2. **Install Python 3.13** from https://python.org
3. **Run the installer** as Administrator
4. **Follow the prompts**

### For Existing Users
1. **Uninstall** current PadelCast Server
2. **Upgrade Python** to 3.13 from https://python.org
3. **Download** new package: `PadelCast_Server_Windows_Python313.zip`
4. **Install** using the new package

## 🔍 Version Checking

### Manual Check
```cmd
python --version
```

### Expected Output
```
Python 3.13.x
```

### If You See Older Version
- **Download Python 3.13** from https://python.org
- **Run installer** as Administrator
- **Check "Add Python to PATH"**
- **Restart computer**

## 🛠️ Troubleshooting

### "Python 3.13 or higher is required"
- **Solution**: Install Python 3.13 from https://python.org
- **Important**: Check "Add Python to PATH" during installation

### "Multiple Python versions detected"
- **Solution**: Use `py -3.13` instead of `python`
- **Alternative**: Set Python 3.13 as default in PATH

### "Dependencies installation failed"
- **Solution**: Run installer as Administrator
- **Check**: Internet connection for package downloads

## 📚 Documentation Updates

### Updated Files
- ✅ `README_Windows.md` - Python 3.13 requirement
- ✅ `WINDOWS_INSTALLATION_GUIDE.md` - Updated instructions
- ✅ `windows_simple_installer.bat` - Version checking
- ✅ `windows_powershell_installer.ps1` - Enhanced validation
- ✅ `start_simple.bat` - Version verification

### New Features
- **Automatic version detection**
- **Clear error messages**
- **Step-by-step upgrade instructions**
- **Enhanced troubleshooting guide**

## 🎯 Migration Guide

### Step 1: Check Current Python
```cmd
python --version
```

### Step 2: Download Python 3.13
- Visit https://python.org
- Download Python 3.13.x
- Run installer as Administrator
- Check "Add Python to PATH"

### Step 3: Verify Installation
```cmd
python --version
# Should show: Python 3.13.x
```

### Step 4: Install PadelCast Server
- Download `PadelCast_Server_Windows_Python313.zip`
- Extract and run installer
- Follow prompts

## 🔒 Security Notes

### Why Python 3.13?
- **Latest security patches**
- **Enhanced SSL/TLS support**
- **Better Windows integration**
- **Improved performance**

### Backward Compatibility
- **Not compatible** with Python 3.8-3.12
- **Requires** Python 3.13 or higher
- **Future-proof** for upcoming features

## 📞 Support

### Getting Help
- **Check Python version**: `python --version`
- **Verify PATH**: `where python`
- **Test installation**: `python -c "print('Hello World')"`

### Common Issues
1. **Old Python version** - Upgrade to 3.13
2. **PATH issues** - Reinstall Python with PATH option
3. **Permission errors** - Run as Administrator

---

**PadelCast Server v1.1** - Python 3.13 Edition  
*Enhanced performance and security for Windows users*
