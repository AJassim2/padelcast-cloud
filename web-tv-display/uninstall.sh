#!/bin/bash

# PadelCast Server Uninstaller
# This script removes the PadelCast server installation

echo "🗑️ PadelCast Server Uninstaller"
echo "================================"

# Stop any running server
if [ -f "/tmp/padelcast_server.pid" ]; then
    PID=$(cat /tmp/padelcast_server.pid)
    if kill -0 $PID 2>/dev/null; then
        echo "🛑 Stopping running server..."
        kill $PID
        rm -f /tmp/padelcast_server.pid
    fi
fi

# Remove desktop shortcut
DESKTOP_SHORTCUT="$HOME/Desktop/PadelCast Server"
if [ -f "$DESKTOP_SHORTCUT" ]; then
    echo "🗑️ Removing desktop shortcut..."
    rm -f "$DESKTOP_SHORTCUT"
fi

# Remove desktop app
APP_DIR="/Applications/PadelCast_Server.app"
if [ -d "$APP_DIR" ]; then
    echo "🗑️ Removing desktop application..."
    rm -rf "$APP_DIR"
fi

# Remove log files
if [ -f "/tmp/padelcast_server.log" ]; then
    echo "🗑️ Removing log files..."
    rm -f /tmp/padelcast_server.log
fi

# Ask about virtual environment
echo ""
read -p "Do you want to remove the virtual environment? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    VENV_DIR="/Users/alijassim/Documents/Codes/venv"
    if [ -d "$VENV_DIR" ]; then
        echo "🗑️ Removing virtual environment..."
        rm -rf "$VENV_DIR"
    fi
fi

echo ""
echo "✅ Uninstallation Complete!"
echo "=========================="
echo "The PadelCast Server has been removed from your system."
echo ""
echo "Note: The web server files are still in the original directory."
echo "To reinstall, run: ./install.sh"
