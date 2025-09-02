#!/bin/bash

# 🚀 PadelCast QR Code System - Railway Deployment Script
# This script helps deploy the new QR code system to Railway

echo "🎾 PadelCast QR Code System - Railway Deployment"
echo "=================================================="

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "app.py" ] || [ ! -f "requirements.txt" ]; then
    echo "❌ Please run this script from the cloud-deployment directory"
    echo "   Current directory: $(pwd)"
    exit 1
fi

echo "✅ Found PadelCast QR Code System files"
echo ""

# Check git status
echo "📋 Checking Git status..."
if [ -d ".git" ]; then
    git_status=$(git status --porcelain)
    if [ -n "$git_status" ]; then
        echo "⚠️  You have uncommitted changes:"
        echo "$git_status"
        echo ""
        echo "💡 Consider committing your changes before deploying:"
        echo "   git add ."
        echo "   git commit -m 'Update QR code system for Railway deployment'"
        echo ""
    else
        echo "✅ All changes are committed"
    fi
    
    echo "🌐 Current Git remote:"
    git remote -v
    echo ""
else
    echo "⚠️  No Git repository found in current directory"
    echo "💡 Make sure you're in the xcode18 directory with Git initialized"
fi

echo "🚀 Railway Deployment Steps:"
echo "=============================="
echo ""
echo "1. 📱 Go to Railway: https://railway.app"
echo "2. 🔐 Sign in with your GitHub account"
echo "3. ➕ Click 'New Project'"
echo "4. 📂 Select 'Deploy from GitHub repo'"
echo "5. 🏗️  Choose your repository (xcode18)"
echo "6. 📁 Set Root Directory to: cloud-deployment"
echo "7. ⚙️  Configure settings:"
echo "    - Start Command: gunicorn --worker-class eventlet -w 1 app:app --bind 0.0.0.0:\$PORT"
echo "    - Environment: Python 3.11+"
echo "8. 🚀 Click 'Deploy'"
echo "9. ⏳ Wait 2-3 minutes for deployment"
echo "10. 🌐 Get your cloud URL: https://your-app-name.railway.app"
echo ""

echo "🧪 After Deployment - Test Your System:"
echo "========================================"
echo "1. 📺 Test TV Setup: https://your-app-name.railway.app/tv"
echo "2. 📱 Verify QR code appears"
echo "3. 🔗 Test iPhone app connection"
echo "4. ⚽ Test score updates"
echo ""

echo "📚 Documentation:"
echo "================="
echo "• Railway Deployment Guide: RAILWAY_QR_SYSTEM.md"
echo "• API Reference: See deployment guide"
echo "• Troubleshooting: Common issues and solutions"
echo ""

echo "🎯 Key Benefits of New System:"
echo "==============================="
echo "✅ Better Security: Unique, unguessable TV sessions"
echo "✅ Improved UX: No manual code coordination"
echo "✅ Scalability: Multiple TVs run independently"
echo "✅ Easy Reset: Fresh start for each new match"
echo ""

echo "🚨 Important Notes:"
echo "==================="
echo "• This is a NEW Railway project (padelcast-qr-system)"
echo "• Separate from your existing PadelCast project"
echo "• Root directory MUST be set to 'cloud-deployment'"
echo "• All dependencies are included in requirements.txt"
echo ""

echo "🎉 Ready to deploy! Follow the steps above to get your QR code system running on Railway."
echo ""
echo "Need help? Check the RAILWAY_QR_SYSTEM.md file for detailed instructions."
