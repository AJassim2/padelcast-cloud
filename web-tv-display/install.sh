#!/bin/bash

# PadelCast Server Installer
# This script installs the PadelCast web server and creates a desktop app

echo "🎾 PadelCast Server Installer"
echo "=============================="

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"

# Create virtual environment
echo "📦 Creating virtual environment..."
python3 -m venv /Users/alijassim/Documents/Codes/venv

if [ $? -ne 0 ]; then
    echo "❌ Failed to create virtual environment"
    exit 1
fi

echo "✅ Virtual environment created"

# Activate virtual environment and install dependencies
echo "📥 Installing dependencies..."
source /Users/alijassim/Documents/Codes/venv/bin/activate
pip3 install --upgrade pip
pip3 install -r "$SCRIPT_DIR/requirements.txt"

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed"

# Create desktop app directory
echo "🖥️ Creating desktop application..."
APP_DIR="/Applications/PadelCast_Server.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Create directory structure
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy the executable
cp "$SCRIPT_DIR/PadelCast_Server.app/Contents/MacOS/PadelCast_Server" "$MACOS_DIR/"
chmod +x "$MACOS_DIR/PadelCast_Server"

# Copy the Info.plist
cp "$SCRIPT_DIR/PadelCast_Server.app/Contents/Info.plist" "$CONTENTS_DIR/"

# Create a simple icon (you can replace this with a proper .icns file later)
echo "🎨 Creating application icon..."
cat > "$RESOURCES_DIR/AppIcon.icns" << 'EOF'
# This is a placeholder for the app icon
# You can replace this with a proper .icns file
EOF

# Create a launcher script that points to the web server directory
cat > "$MACOS_DIR/launcher.sh" << EOF
#!/bin/bash
cd "$SCRIPT_DIR"
source /Users/alijassim/Documents/Codes/venv/bin/activate
exec "\$0" "\$@"
EOF

chmod +x "$MACOS_DIR/launcher.sh"

# Create desktop shortcut
echo "🖥️ Creating desktop shortcut..."
DESKTOP_DIR="$HOME/Desktop"
SHORTCUT="$DESKTOP_DIR/PadelCast Server"

# Create a simple script that launches the app
cat > "$SHORTCUT" << 'EOF'
#!/bin/bash
open "/Applications/PadelCast_Server.app"
EOF

chmod +x "$SHORTCUT"

echo "✅ Desktop shortcut created: $SHORTCUT"

# Create a README file
echo "📖 Creating documentation..."
cat > "$SCRIPT_DIR/README_User.md" << 'EOF'
# PadelCast Server - User Guide

## Quick Start

1. **Double-click** the "PadelCast Server" icon on your desktop
2. Choose "Start Server" from the menu
3. Click "Open Browser" when prompted
4. Enter team names and generate a code
5. Use that code in your iPhone app

## Features

- 🎾 **Easy Start/Stop**: Simple menu interface
- 🌐 **Web Interface**: Generate codes and view TV displays
- 📱 **iPhone Integration**: Sync team names and scores
- 📺 **TV Display**: Full-screen score display for TVs
- 🔄 **Real-time Updates**: Live score updates

## URLs

- **Web Interface**: http://192.168.100.180:8080
- **TV Display**: http://192.168.100.180:8080/tv/[CODE]

## Troubleshooting

- **Server won't start**: Make sure no other app is using port 8080
- **Can't connect**: Check that your iPhone and computer are on the same WiFi network
- **Virtual environment error**: Run the installer again

## Support

For issues, check the logs at: /tmp/padelcast_server.log
EOF

echo "✅ Documentation created"

# Test the installation
echo "🧪 Testing installation..."
source /Users/alijassim/Documents/Codes/venv/bin/activate
python3 -c "import flask, flask_socketio; print('✅ All dependencies working')"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Installation Complete!"
    echo "========================"
    echo "✅ Virtual environment created"
    echo "✅ Dependencies installed"
    echo "✅ Desktop app created: /Applications/PadelCast_Server.app"
    echo "✅ Desktop shortcut created: $SHORTCUT"
    echo ""
    echo "🚀 To start the server:"
    echo "   1. Double-click 'PadelCast Server' on your desktop"
    echo "   2. Choose 'Start Server'"
    echo "   3. Click 'Open Browser' when prompted"
    echo ""
    echo "📖 User guide: $SCRIPT_DIR/README_User.md"
else
    echo "❌ Installation test failed"
    exit 1
fi
