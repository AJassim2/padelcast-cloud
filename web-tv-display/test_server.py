#!/usr/bin/env python3
"""
Test script for PadelCast TV Web Server
"""

import requests
import json
import time

BASE_URL = "shttp://localhost:8080"

def test_generate_code():
    """Test generating a match code"""
    print("🧪 Testing code generation...")
    
    data = {
        "team1_name": "Test Team 1",
        "team2_name": "Test Team 2"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/generate-code", json=data)
        result = response.json()
        
        if result.get('success'):
            print(f"✅ Code generated successfully: {result['code']}")
            print(f"📺 TV URL: {BASE_URL}{result['tv_url']}")
            return result['code']
        else:
            print(f"❌ Failed to generate code: {result.get('error')}")
            return None
            
    except Exception as e:
        print(f"❌ Error testing code generation: {e}")
        return None

def test_update_match(code):
    """Test updating match data"""
    print(f"\n🧪 Testing match update with code: {code}")
    
    data = {
        "code": code,
        "team1_game_score": "15",
        "team2_game_score": "30",
        "team1_games": 1,
        "team2_games": 2,
        "team1_sets": 0,
        "team2_sets": 1,
        "is_match_finished": False,
        "winning_team": None
    }
    
    try:
        response = requests.post(f"{BASE_URL}/api/update-match", json=data)
        result = response.json()
        
        if result.get('success'):
            print("✅ Match updated successfully")
        else:
            print(f"❌ Failed to update match: {result.get('error')}")
            
    except Exception as e:
        print(f"❌ Error testing match update: {e}")

def test_match_status(code):
    """Test getting match status"""
    print(f"\n🧪 Testing match status for code: {code}")
    
    try:
        response = requests.get(f"{BASE_URL}/api/match-status/{code}")
        result = response.json()
        
        if result.get('success'):
            match = result['match']
            print("✅ Match status retrieved successfully:")
            print(f"   Team 1: {match['team1_name']} - Game: {match['team1_game_score']}, Games: {match['team1_games']}, Sets: {match['team1_sets']}")
            print(f"   Team 2: {match['team2_name']} - Game: {match['team2_game_score']}, Games: {match['team2_games']}, Sets: {match['team2_sets']}")
        else:
            print(f"❌ Failed to get match status: {result.get('error')}")
            
    except Exception as e:
        print(f"❌ Error testing match status: {e}")

def main():
    """Run all tests"""
    print("🎾 PadelCast TV Web Server Test")
    print("=" * 40)
    
    # Test server is running
    try:
        response = requests.get(BASE_URL)
        if response.status_code == 200:
            print("✅ Web server is running")
        else:
            print(f"❌ Web server returned status code: {response.status_code}")
            return
    except Exception as e:
        print(f"❌ Cannot connect to web server: {e}")
        print("Make sure the server is running with: python3 app.py")
        return
    
    # Test code generation
    code = test_generate_code()
    if not code:
        return
    
    # Wait a moment
    time.sleep(1)
    
    # Test match update
    test_update_match(code)
    
    # Wait a moment
    time.sleep(1)
    
    # Test match status
    test_match_status(code)
    
    print("\n🎯 Test completed!")
    print(f"📱 You can now test with your iPhone app using code: {code}")
    print(f"📺 Open this URL on your TV: {BASE_URL}/tv/{code}")

if __name__ == "__main__":
    main()
