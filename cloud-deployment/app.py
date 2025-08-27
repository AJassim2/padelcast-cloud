from flask import Flask, render_template, request, jsonify, session
from flask_socketio import SocketIO, emit, join_room, leave_room
import uuid
import json
from datetime import datetime
import threading
import time

app = Flask(__name__)
app.config['SECRET_KEY'] = 'padel-cast-secret-key-2024'
socketio = SocketIO(app, cors_allowed_origins="*")

# Store active matches and their data
active_matches = {}
match_codes = {}  # code -> match_id mapping

class Match:
    def __init__(self, match_id, team1_name, team2_name, best_of_sets=5):
        self.match_id = match_id
        self.team1_name = team1_name
        self.team2_name = team2_name
        self.team1_game_score = "0"
        self.team2_game_score = "0"
        self.best_of_sets = best_of_sets
        
        # Initialize dynamic set game counters
        self.team1_set_games = {}
        self.team2_set_games = {}
        for i in range(1, best_of_sets + 1):
            self.team1_set_games[i] = 0
            self.team2_set_games[i] = 0
        
        # Current set being played
        self.current_set = 1
        
        self.is_match_finished = False
        self.winning_team = None
        self.created_at = datetime.now()
        self.last_updated = datetime.now()
    
    def get_team1_set_games(self, set_num):
        return self.team1_set_games.get(set_num, 0)
    
    def get_team2_set_games(self, set_num):
        return self.team2_set_games.get(set_num, 0)

def generate_match_code():
    """Generate a unique 6-character code for the match"""
    return str(uuid.uuid4())[:6].upper()

def convert_tennis_score(points):
    """Convert point count to tennis score display"""
    try:
        points_int = int(points)
        if points_int == 0:
            return "0"
        elif points_int == 1:
            return "15"
        elif points_int == 2:
            return "30"
        elif points_int == 3:
            return "40"
        elif points_int == 4:
            return "AD"  # Advantage
        else:
            return str(points_int)
    except (ValueError, TypeError):
        # If conversion fails, return the original value
        return str(points)

@app.route('/')
def index():
    """Main page to generate a new match code"""
    return render_template('index.html')

@app.route('/generate-code', methods=['POST'])
def generate_code():
    """Generate a new match code"""
    data = request.get_json()
    team1_name = data.get('team1_name', 'Team 1')
    team2_name = data.get('team2_name', 'Team 2')
    best_of_sets = data.get('best_of_sets', 5)  # Default to 5 if not provided
    
    # Generate unique match ID and code
    match_id = str(uuid.uuid4())
    code = generate_match_code()
    
    # Create new match with best_of_sets
    match = Match(match_id, team1_name, team2_name, best_of_sets)
    active_matches[match_id] = match
    match_codes[code] = match_id
    
    print(f"🚀 Generated code {code} for match {match_id} with Best of {best_of_sets} sets - Cloud updated at {datetime.now()}")
    
    return jsonify({
        'success': True,
        'code': code,
        'match_id': match_id,
        'tv_url': f'/tv/{code}'
    })

@app.route('/tv/<code>')
def tv_display(code):
    """TV display page for a specific match code"""
    match_id = match_codes.get(code)
    if not match_id:
        return render_template('error.html', message="Invalid match code")
    
    match = active_matches.get(match_id)
    if not match:
        return render_template('error.html', message="Match not found")
    
    return render_template('tv_display.html', 
                         code=code, 
                         match=match,
                         team1_name=match.team1_name,
                         team2_name=match.team2_name,
                         best_of_sets=match.best_of_sets)

@app.route('/api/update-match', methods=['POST'])
def update_match():
    """API endpoint for iPhone app to update match data"""
    print(f"📱 Received update request from iPhone app")
    data = request.get_json()
    print(f"📱 Request data: {data}")
    print(f"🚀 Cloud server updated at: {datetime.now()}")
    
    code = data.get('code')
    print(f"📱 Code: {code}")
    
    if not code or code not in match_codes:
        print(f"❌ Invalid code: {code}")
        print(f"📋 Available codes: {list(match_codes.keys())}")
        return jsonify({'success': False, 'error': 'Invalid code'}), 400
    
    match_id = match_codes[code]
    match = active_matches.get(match_id)
    
    if not match:
        print(f"❌ Match not found for ID: {match_id}")
        return jsonify({'success': False, 'error': 'Match not found'}), 404
    
    print(f"📱 Updating match {match_id} with data: {data}")
    
    # Update match data
    if 'team1_name' in data:
        match.team1_name = data.get('team1_name', match.team1_name)
    if 'team2_name' in data:
        match.team2_name = data.get('team2_name', match.team2_name)
    match.team1_game_score = data.get('team1_game_score', match.team1_game_score)
    match.team2_game_score = data.get('team2_game_score', match.team2_game_score)
    
    # Update set game scores
    for i in range(1, match.best_of_sets + 1):
        set_num = f"set{i}_games"
        if set_num in data:
            set_games = data.get(set_num)
            if set_games is not None:
                print(f"📱 Processing {set_num}: {set_games}")
                match.team1_set_games[i] = set_games[0]
                match.team2_set_games[i] = set_games[1]
                print(f"📱 Set {i} - Team 1: {match.team1_set_games[i]}, Team 2: {match.team2_set_games[i]}")
    
    match.current_set = data.get('current_set', match.current_set)
    match.is_match_finished = data.get('is_match_finished', match.is_match_finished)
    match.winning_team = data.get('winning_team', match.winning_team)
    match.last_updated = datetime.now()
    
    # Convert scores to tennis format for display
    team1_display_score = convert_tennis_score(match.team1_game_score)
    team2_display_score = convert_tennis_score(match.team2_game_score)
    
    print(f"📱 Converted scores - Team 1: {match.team1_game_score} -> {team1_display_score}")
    print(f"📱 Converted scores - Team 2: {match.team2_game_score} -> {team2_display_score}")
    
    # Prepare update data
    update_data = {
        'team1_name': match.team1_name,
        'team2_name': match.team2_name,
        'team1_game_score': team1_display_score,
        'team2_game_score': team2_display_score,
        'current_set': match.current_set,
        'is_match_finished': match.is_match_finished,
        'winning_team': match.winning_team,
        'last_updated': match.last_updated.isoformat(),
        'best_of_sets': match.best_of_sets
    }
    
    # Add dynamic set scores
    for i in range(1, match.best_of_sets + 1):
        update_data[f'team1_set{i}_games'] = match.team1_set_games[i]
        update_data[f'team2_set{i}_games'] = match.team2_set_games[i]
    
    print(f"📺 Emitting update to room {code} with data: {update_data}")
    print(f"📺 Set scores being sent (Best of {match.best_of_sets}):")
    for i in range(1, match.best_of_sets + 1):
        print(f"   Set {i}: Team 1 = {update_data[f'team1_set{i}_games']}, Team 2 = {update_data[f'team2_set{i}_games']}")
    
    # Emit update to all connected TV displays
    socketio.emit('match_update', update_data, room=code)
    
    print(f"✅ Successfully updated match {match_id} via code {code}")
    
    return jsonify({'success': True})

@socketio.on('join')
def on_join(data):
    """Handle TV display joining a match room"""
    code = data['code']
    join_room(code)
    print(f"TV display joined room: {code}")

@socketio.on('disconnect')
def on_disconnect():
    """Handle TV display disconnection"""
    print("TV display disconnected")

@app.route('/api/match-status/<code>')
def match_status(code):
    """Get current match status"""
    match_id = match_codes.get(code)
    if not match_id:
        return jsonify({'success': False, 'error': 'Invalid code'}), 400
    
    match = active_matches.get(match_id)
    if not match:
        return jsonify({'success': False, 'error': 'Match not found'}), 404
    
    # Convert scores to tennis format for display
    team1_display_score = convert_tennis_score(match.team1_game_score)
    team2_display_score = convert_tennis_score(match.team2_game_score)
    
    return jsonify({
        'success': True,
        'match': {
            'team1_name': match.team1_name,
            'team2_name': match.team2_name,
            'team1_game_score': team1_display_score,
            'team2_game_score': team2_display_score,
            'team1_set1_games': match.team1_set1_games,
            'team2_set1_games': match.team2_set1_games,
            'team1_set2_games': match.team1_set2_games,
            'team2_set2_games': match.team2_set2_games,
            'team1_set3_games': match.team1_set3_games,
            'team2_set3_games': match.team2_set3_games,
            'team1_set4_games': match.team1_set4_games,
            'team2_set4_games': match.team2_set4_games,
            'team1_set5_games': match.team1_set5_games,
            'team2_set5_games': match.team2_set5_games,
            'current_set': match.current_set,
            'is_match_finished': match.is_match_finished,
            'winning_team': match.winning_team,
            'last_updated': match.last_updated.isoformat()
        }
    })

# Cleanup old matches (older than 24 hours)
def cleanup_old_matches():
    """Remove matches older than 24 hours"""
    while True:
        current_time = datetime.now()
        to_remove = []
        
        for match_id, match in active_matches.items():
            if (current_time - match.created_at).total_seconds() > 86400:  # 24 hours
                to_remove.append(match_id)
        
        for match_id in to_remove:
            del active_matches[match_id]
            # Remove from match_codes
            codes_to_remove = [code for code, mid in match_codes.items() if mid == match_id]
            for code in codes_to_remove:
                del match_codes[code]
        
        if to_remove:
            print(f"Cleaned up {len(to_remove)} old matches")
        
        time.sleep(3600)  # Run every hour

# Start cleanup thread
cleanup_thread = threading.Thread(target=cleanup_old_matches, daemon=True)
cleanup_thread.start()

if __name__ == '__main__':
    print("🎾 PadelCast TV Web Server Starting...")
    print("📱 Generate codes at: http://localhost:8080")
    print("📺 TV displays at: http://localhost:8080/tv/<CODE>")
    socketio.run(app, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)), debug=False)
