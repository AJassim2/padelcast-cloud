import requests
import json
import os
from datetime import datetime

class PadelCastCloudAPI:
    def __init__(self, base_url=None):
        # Use environment variable for cloud URL or default to localhost
        self.base_url = base_url or os.environ.get('PADELCAST_CLOUD_URL', 'http://localhost:8080')
        
    def generate_code(self, team1_name="Team A", team2_name="Team B"):
        """Generate a new match code from the cloud server"""
        try:
            data = {
                'team1_name': team1_name,
                'team2_name': team2_name
            }
            response = requests.post(f"{self.base_url}/generate-code", json=data, headers={'Content-Type': 'application/json'}, timeout=10)
            if response.status_code == 200:
                data = response.json()
                return {
                    'success': True,
                    'code': data.get('code'),
                    'match_id': data.get('match_id'),
                    'tv_url': f"{self.base_url}/tv/{data.get('code')}",
                    'timestamp': datetime.now().isoformat()
                }
            else:
                return {
                    'success': False,
                    'error': f'Server error: {response.status_code}',
                    'timestamp': datetime.now().isoformat()
                }
        except requests.exceptions.RequestException as e:
            return {
                'success': False,
                'error': f'Network error: {str(e)}',
                'timestamp': datetime.now().isoformat()
            }
    
    def get_match_status(self, code):
        """Get current match status from the cloud server"""
        try:
            response = requests.get(f"{self.base_url}/api/match-status/{code}", timeout=10)
            if response.status_code == 200:
                return {
                    'success': True,
                    'data': response.json(),
                    'timestamp': datetime.now().isoformat()
                }
            else:
                return {
                    'success': False,
                    'error': f'Match not found or server error: {response.status_code}',
                    'timestamp': datetime.now().isoformat()
                }
        except requests.exceptions.RequestException as e:
            return {
                'success': False,
                'error': f'Network error: {str(e)}',
                'timestamp': datetime.now().isoformat()
            }
    
    def update_match(self, code, match_data):
        """Update match data on the cloud server"""
        try:
            # Add the code to the match data
            match_data['code'] = code
            
            response = requests.post(
                f"{self.base_url}/api/update-match",
                json=match_data,
                headers={'Content-Type': 'application/json'},
                timeout=10
            )
            
            if response.status_code == 200:
                return {
                    'success': True,
                    'data': response.json(),
                    'timestamp': datetime.now().isoformat()
                }
            else:
                return {
                    'success': False,
                    'error': f'Update failed: {response.status_code}',
                    'timestamp': datetime.now().isoformat()
                }
        except requests.exceptions.RequestException as e:
            return {
                'success': False,
                'error': f'Network error: {str(e)}',
                'timestamp': datetime.now().isoformat()
            }
    
    def get_server_info(self):
        """Get server information and status"""
        try:
            response = requests.get(f"{self.base_url}/", timeout=5)
            return {
                'success': True,
                'status': 'online',
                'response_time': response.elapsed.total_seconds(),
                'timestamp': datetime.now().isoformat()
            }
        except requests.exceptions.RequestException as e:
            return {
                'success': False,
                'status': 'offline',
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            }

# Example usage
if __name__ == "__main__":
    # Test the cloud API
    api = PadelCastCloudAPI()
    
    # Test server connection
    print("🔍 Testing server connection...")
    server_info = api.get_server_info()
    print(f"Server status: {server_info}")
    
    if server_info['success']:
        # Generate a code
        print("\n🎾 Generating match code...")
        result = api.generate_code()
        print(f"Generate result: {result}")
        
        if result['success']:
            code = result['code']
            tv_url = result['tv_url']
            
            print(f"\n📺 TV Display URL: {tv_url}")
            print(f"📱 Use this code in your iPhone app: {code}")
            
            # Test match status
            print(f"\n📊 Getting match status for code: {code}")
            status = api.get_match_status(code)
            print(f"Status: {status}")
    else:
        print("❌ Server is not accessible. Make sure the server is running.")
