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
    def __init__(self, match_id, team1_name, team2_name):
        self.match_id = match_id
        self.team1_name = team1_name
        self.team2_name = team2_name
        self.team1_game_score = "0"
        self.team2_game_score = "0"
        self.team1_games = 0
        self.team2_games = 0
        self.team1_sets = 0
        self.team2_sets = 0
        # Individual set scores (like tennis scoreboard)
        self.team1_set_scores = ["-", "-", "-", "-", "-"]  # Set 1-5
        self.team2_set_scores = ["-", "-", "-", "-", "-"]  # Set 1-5
        self.current_set = 1
        self.is_match_finished = False
        self.winning_team = None
        self.created_at = datetime.now()
        self.last_updated = datetime.now()

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
    
    # Generate unique match ID and code
    match_id = str(uuid.uuid4())
    code = generate_match_code()
    
    # Create new match
    match = Match(match_id, team1_name, team2_name)
    active_matches[match_id] = match
    match_codes[code] = match_id
    
    print(f"Generated code {code} for match {match_id}")
    
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
                         team2_name=match.team2_name)

@app.route('/api/update-match', methods=['POST'])
def update_match():
    """API endpoint for iPhone app to update match data"""
    print(f"📱 Received update request from iPhone app")
    data = request.get_json()
    print(f"📱 Request data: {data}")
    
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
    match.team1_games = data.get('team1_games', match.team1_games)
    match.team2_games = data.get('team2_games', match.team2_games)
    match.team1_sets = data.get('team1_sets', match.team1_sets)
    match.team2_sets = data.get('team2_sets', match.team2_sets)
    match.is_match_finished = data.get('is_match_finished', match.is_match_finished)
    match.winning_team = data.get('winning_team', match.winning_team)
    match.last_updated = datetime.now()
    
    # Check if match is being reset (both sets are 0 and not finished)
    if match.team1_sets == 0 and match.team2_sets == 0 and not match.is_match_finished:
        # Reset set scores when match is reset
        match.team1_set_scores = ["-", "-", "-", "-", "-"]
        match.team2_set_scores = ["-", "-", "-", "-", "-"]
        print(f"🔄 Match reset - cleared set scores")
    elif match.team1_sets > 0 or match.team2_sets > 0:
        # Update set scores based on current set
        total_sets_played = match.team1_sets + match.team2_sets
        
        for set_num in range(1, min(total_sets_played + 1, 6)):
            if set_num <= len(match.team1_set_scores):
                # For completed sets, show realistic scores
                if set_num <= match.team1_sets:
                    # Team 1 won this set
                    match.team1_set_scores[set_num - 1] = "6"
                    match.team2_set_scores[set_num - 1] = "0"
                elif set_num <= total_sets_played:
                    # Team 2 won this set (since Team 1 didn't win it)
                    match.team1_set_scores[set_num - 1] = "0"
                    match.team2_set_scores[set_num - 1] = "6"
        
        print(f"🎾 Updated set scores - Team 1: {match.team1_set_scores}, Team 2: {match.team2_set_scores}")
    
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
        'team1_games': match.team1_games,
        'team2_games': match.team2_games,
        'team1_sets': match.team1_sets,
        'team2_sets': match.team2_sets,
        'team1_set_scores': match.team1_set_scores,
        'team2_set_scores': match.team2_set_scores,
        'is_match_finished': match.is_match_finished,
        'winning_team': match.winning_team,
        'last_updated': match.last_updated.isoformat()
    }
    
    print(f"📺 Emitting update to room {code} with data: {update_data}")
    
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
            'team1_games': match.team1_games,
            'team2_games': match.team2_games,
            'team1_sets': match.team1_sets,
            'team2_sets': match.team2_sets,
            'team1_set_scores': match.team1_set_scores,
            'team2_set_scores': match.team2_set_scores,
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
    socketio.run(app, host='0.0.0.0', port=8080, debug=True)
