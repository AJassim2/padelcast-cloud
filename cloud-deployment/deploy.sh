#!/bin/bash

# PadelCast Cloud Deployment Script
echo "☁️ PadelCast Cloud Deployment"
echo "=============================="

# Check if Heroku CLI is installed
if ! command -v heroku &> /dev/null; then
    echo "❌ Heroku CLI not found. Installing..."
    
    # Install Heroku CLI based on OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install heroku/brew/heroku
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl https://cli-assets.heroku.com/install.sh | sh
    else
        echo "❌ Please install Heroku CLI manually: https://devcenter.heroku.com/articles/heroku-cli"
        exit 1
    fi
fi

# Check if user is logged in to Heroku
if ! heroku auth:whoami &> /dev/null; then
    echo "🔐 Please login to Heroku..."
    heroku login
fi

# Get app name from user
echo ""
read -p "Enter your Heroku app name (or press Enter for auto-generated): " APP_NAME

if [ -z "$APP_NAME" ]; then
    echo "🎯 Creating new Heroku app..."
    heroku create
    APP_NAME=$(heroku apps:info --json | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
else
    echo "🎯 Creating app: $APP_NAME"
    heroku create $APP_NAME
fi

echo "✅ App created: $APP_NAME"

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repository..."
    git init
fi

# Add all files
echo "📁 Adding files to git..."
git add .

# Commit changes
echo "💾 Committing changes..."
git commit -m "Initial PadelCast deployment"

# Deploy to Heroku
echo "🚀 Deploying to Heroku..."
git push heroku main

# Get the app URL
APP_URL=$(heroku info -s | grep web_url | cut -d= -f2)
echo ""
echo "🎉 Deployment successful!"
echo "📱 Your PadelCast app is now live at: $APP_URL"
echo ""
echo "🌐 API Endpoints:"
echo "   Generate Code: $APP_URL/generate-code"
echo "   TV Display: $APP_URL/tv/CODE"
echo "   Match Status: $APP_URL/api/match-status/CODE"
echo ""
echo "📺 To use with your iPhone app:"
echo "   1. Update your iPhone app with this URL: $APP_URL"
echo "   2. Generate codes from your iPhone app"
echo "   3. Open TV URLs on your TV browser"
echo "   4. Enjoy live scoring!"
echo ""
echo "🔧 To view logs: heroku logs --tail"
echo "🔧 To restart: heroku restart"
