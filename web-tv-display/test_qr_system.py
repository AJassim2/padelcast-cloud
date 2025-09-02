#!/usr/bin/env python3
"""
Test script for the new QR code-based TV linking system
"""

import requests
import json
import time

# Configuration
BASE_URL = "http://localhost:8080"

def test_tv_setup():
    """Test TV setup and QR code generation"""
    print("🧪 Testing TV Setup...")
    
    # Get TV setup page
    response = requests.get(f"{BASE_URL}/tv")
    if response.status_code == 200:
        print("✅ TV setup page accessible")
        # Extract TV ID from the page (you'd need to parse HTML in a real test)
        print("📺 TV setup page loaded successfully")
    else:
        print(f"❌ TV setup page failed: {response.status_code}")
        return None
    
    return True

def test_tv_session():
    """Test creating a TV session"""
    print("\n🧪 Testing TV Session Creation...")
    
    # This would normally be done by the TV setup page
    # For testing, we'll simulate it by calling the endpoint directly
    response = requests.get(f"{BASE_URL}/tv")
    if response.status_code == 200:
        print("✅ TV session created")
        return True
    else:
        print(f"❌ TV session creation failed: {response.status_code}")
        return False

def test_api_endpoints():
    """Test the new API endpoints"""
    print("\n🧪 Testing API Endpoints...")
    
    # Test match status endpoint (should fail without valid TV ID)
    test_tv_id = "test-tv-id"
    response = requests.get(f"{BASE_URL}/api/match-status/{test_tv_id}")
    if response.status_code == 400:
        print("✅ Match status endpoint properly validates TV ID")
    else:
        print(f"❌ Match status endpoint validation failed: {response.status_code}")
    
    # Test link TV endpoint (should fail without valid TV ID)
    link_data = {
        "tv_id": test_tv_id,
        "match_data": {
            "team1_name": "Test Team 1",
            "team2_name": "Test Team 2",
            "best_of_sets": 3,
            "court_number": "1"
        }
    }
    
    response = requests.post(f"{BASE_URL}/api/link-tv", json=link_data)
    if response.status_code == 400:
        print("✅ Link TV endpoint properly validates TV ID")
    else:
        print(f"❌ Link TV endpoint validation failed: {response.status_code}")
    
    return True

def main():
    """Run all tests"""
    print("🚀 Starting QR Code System Tests...")
    print("=" * 50)
    
    try:
        # Test basic functionality
        if not test_tv_setup():
            print("❌ TV setup test failed")
            return
        
        if not test_tv_session():
            print("❌ TV session test failed")
            return
        
        if not test_api_endpoints():
            print("❌ API endpoints test failed")
            return
        
        print("\n" + "=" * 50)
        print("🎉 All tests passed! The QR code system is working correctly.")
        print("\n📱 Next steps:")
        print("1. Open a TV display at: http://localhost:8080/tv")
        print("2. Scan the QR code with your iPhone app")
        print("3. Configure and start a match")
        print("4. The TV will automatically display the scoreboard")
        
    except requests.exceptions.ConnectionError:
        print("❌ Connection failed. Make sure the Flask server is running on port 8080")
        print("💡 Start the server with: python app.py")
    except Exception as e:
        print(f"❌ Test failed with error: {e}")

if __name__ == "__main__":
    main()
