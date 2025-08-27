#!/bin/bash

# PadelCast Xcode 15+ Build Verification Script
# This script verifies that the upgraded project builds successfully

echo "🏗️  PadelCast Xcode 15+ Build Verification"
echo "=========================================="
echo ""

# Check Xcode version
echo "📱 Checking Xcode version..."
xcode_version=$(xcodebuild -version | head -n 1)
echo "   $xcode_version"
echo ""

# Navigate to project directory
PROJECT_DIR="PadelCast"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Project directory not found: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"

# Check if project file exists
PROJECT_FILE="PadelCast.xcodeproj"
if [ ! -d "$PROJECT_FILE" ]; then
    echo "❌ Project file not found: $PROJECT_FILE"
    exit 1
fi

echo "🔨 Building iOS App..."
xcodebuild -project "$PROJECT_FILE" \
           -scheme "PadelCast" \
           -destination "platform=iOS Simulator,name=iPhone 15,OS=latest" \
           clean build \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           -quiet

if [ $? -eq 0 ]; then
    echo "✅ iOS App build successful"
else
    echo "❌ iOS App build failed"
    exit 1
fi

echo ""
echo "🔨 Building Watch App..."
xcodebuild -project "$PROJECT_FILE" \
           -scheme "PadelCast Watch App Watch App" \
           -destination "platform=watchOS Simulator,name=Apple Watch Series 9 (45mm),OS=latest" \
           clean build \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           -quiet

if [ $? -eq 0 ]; then
    echo "✅ Watch App build successful"
else
    echo "❌ Watch App build failed"
    exit 1
fi

echo ""
echo "🎉 All builds completed successfully!"
echo "📋 Next steps:"
echo "   1. Open PadelCast.xcodeproj in Xcode 15+"
echo "   2. Select your target device (iOS 17+ required)"
echo "   3. Build and run the project"
echo "   4. Test AirPlay functionality with Apple TV"
echo ""
echo "✨ Your PadelCast app is ready for Xcode 15+!" 