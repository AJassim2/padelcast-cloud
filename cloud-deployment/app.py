from flask import Flask, render_template, request, jsonify, session
from flask_socketio import SocketIO, emit, join_room, leave_room
import uuid
import json
import os
from datetime import datetime
import threading
import time
import qrcode
import base64
from io import BytesIO

app = Flask(__name__)
app.config['SECRET_KEY'] = 'padel-cast-qr-system-2024'
socketio = SocketIO(app, cors_allowed_origins="*")

# Store active matches and their data
active_matches = {}
match_codes = {}  # code -> match_id mapping
tv_sessions = {}  # tv_id -> session_data mapping

class Match:
    def __init__(self, match_id, team1_name, team2_name, best_of_sets=5, court_number="1", championship_name="PADELCAST CHAMPIONSHIP", court_logo_data=None, team1_player1="Player 1", team1_player2="Player 2", team2_player1="Player 3", team2_player2="Player 4"):
        self.match_id = match_id
        self.team1_name = team1_name
        self.team2_name = team2_name
        self.team1_player1 = team1_player1
        self.team1_player2 = team1_player2
        self.team2_player1 = team2_player1
        self.team2_player2 = team2_player2
        self.team1_game_score = "0"
        self.team2_game_score = "0"
        self.best_of_sets = best_of_sets
        self.court_number = court_number
        self.championship_name = championship_name
        self.court_logo_data = court_logo_data
        
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

def generate_tv_session():
    """Generate a unique TV session ID and QR code"""
    tv_id = str(uuid.uuid4())
    
    # Create QR code data
    qr_data = {
        'tv_id': tv_id,
        'server_url': request.host_url.rstrip('/'),
        'timestamp': datetime.now().isoformat()
    }
    
    try:
        # Generate QR code
        qr = qrcode.QRCode(version=1, box_size=10, border=5)
        qr.add_data(json.dumps(qr_data))
        qr.make(fit=True)
        
        # Create QR code image
        img = qr.make_image(fill_color="black", back_color="white")
        
        # Convert to base64 for embedding in HTML
        buffer = BytesIO()
        img.save(buffer, format='PNG')
        qr_base64 = base64.b64encode(buffer.getvalue()).decode()
        
        print(f"✅ QR code generated successfully for TV {tv_id}")
        
    except Exception as e:
        print(f"❌ Error generating QR code: {e}")
        # Fallback: create a simple text-based QR representation
        qr_base64 = None
        qr_data['error'] = str(e)
    
    # Store TV session
    tv_sessions[tv_id] = {
        'created_at': datetime.now(),
        'qr_code': qr_base64,
        'qr_data': qr_data,
        'linked_match_id': None,
        'is_active': True
    }
    
    return tv_id, qr_base64, qr_data

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
    """Main page - now shows TV setup instructions"""
    # Generate TV session for the main page
    tv_id, qr_base64, qr_data = generate_tv_session()
    return render_template('tv_setup.html', 
                         tv_id=tv_id, 
                         qr_code=qr_base64, 
                         qr_data=qr_data)

@app.route('/tv')
def tv_setup():
    """TV setup page - generates unique QR code for this TV"""
    tv_id, qr_base64, qr_data = generate_tv_session()
    return render_template('tv_setup.html', 
                         tv_id=tv_id, 
                         qr_code=qr_base64, 
                         qr_data=qr_data)

@app.route('/tv/<tv_id>')
def tv_display(tv_id):
    """TV display page for a specific TV session"""
    if tv_id not in tv_sessions:
        return render_template('error.html', message="Invalid TV session")
    
    tv_session = tv_sessions[tv_id]
    
    # If no match is linked, show QR code
    if not tv_session['linked_match_id']:
        return render_template('tv_qr_display.html', 
                             tv_id=tv_id, 
                             qr_code=tv_session['qr_code'],
                             qr_data=tv_session['qr_data'])
    
    # If match is linked, show the match display
    match_id = tv_session['linked_match_id']
    match = active_matches.get(match_id)
    
    if not match:
        # Clear the link if match doesn't exist
        tv_session['linked_match_id'] = None
        return render_template('tv_qr_display.html', 
                             tv_id=tv_id, 
                             qr_code=tv_session['qr_code'],
                             qr_data=tv_session['qr_data'])
    
    return render_template('tv_display.html', 
                         tv_id=tv_id,
                         code=match_id, 
                         match=match,
                         team1_name=match.team1_name,
                         team2_name=match.team2_name,
                         team1_player1=match.team1_player1,
                         team1_player2=match.team1_player2,
                         team2_player1=match.team2_player1,
                         team2_player2=match.team2_player2,
                         best_of_sets=match.best_of_sets,
                         court_number=match.court_number,
                         championship_name=match.championship_name,
                         court_logo_data=match.court_logo_data)

@app.route('/api/link-tv', methods=['POST'])
def link_tv():
    """API endpoint for iPhone app to link to a TV via QR code"""
    data = request.get_json()
    tv_id = data.get('tv_id')
    match_data = data.get('match_data', {})
    
    if not tv_id or tv_id not in tv_sessions:
        return jsonify({'success': False, 'error': 'Invalid TV ID'}), 400
    
    tv_session = tv_sessions[tv_id]
    
    # Create new match
    match_id = str(uuid.uuid4())
    code = generate_match_code()
    
    team1_name = match_data.get('team1_name', 'Team 1')
    team2_name = match_data.get('team2_name', 'Team 2')
    best_of_sets = match_data.get('best_of_sets', 5)
    court_number = match_data.get('court_number', '1')
    championship_name = match_data.get('championship_name', 'PADELCAST CHAMPIONSHIP')
    court_logo_data = match_data.get('court_logo_data')
    team1_player1 = match_data.get('team1_player1', 'Player 1')
    team1_player2 = match_data.get('team1_player2', 'Player 2')
    team2_player1 = match_data.get('team2_player1', 'Player 3')
    team2_player2 = match_data.get('team2_player2', 'Player 4')
    
    match = Match(match_id, team1_name, team2_name, best_of_sets, court_number, 
                  championship_name, court_logo_data, team1_player1, team1_player2, 
                  team2_player1, team2_player2)
    
    active_matches[match_id] = match
    match_codes[code] = match_id
    
    # Link TV to match
    tv_session['linked_match_id'] = match_id
    
    print(f"📱 TV {tv_id} linked to match {match_id} with code {code}")
    
    return jsonify({
        'success': True,
        'match_id': match_id,
        'code': code,
        'tv_id': tv_id
    })

@app.route('/api/reset-tv/<tv_id>', methods=['POST'])
def reset_tv(tv_id):
    """Reset TV session and generate new QR code"""
    if tv_id not in tv_sessions:
        return jsonify({'success': False, 'error': 'Invalid TV ID'}), 400
    
    tv_session = tv_sessions[tv_id]
    
    # Clear linked match
    if tv_session['linked_match_id']:
        match_id = tv_session['linked_match_id']
        if match_id in active_matches:
            del active_matches[match_id]
        # Remove from match_codes
        codes_to_remove = [code for code, mid in match_codes.items() if mid == match_id]
        for code in codes_to_remove:
            del match_codes[code]
    
    # Generate new QR code
    new_tv_id, qr_base64, qr_data = generate_tv_session()
    
    # Update the existing session
    tv_sessions[new_tv_id] = tv_sessions[tv_id]
    tv_sessions[new_tv_id]['qr_code'] = qr_base64
    tv_sessions[new_tv_id]['qr_data'] = qr_data
    tv_sessions[new_tv_id]['linked_match_id'] = None
    
    # Remove old session
    del tv_sessions[tv_id]
    
    print(f"🔄 TV {tv_id} reset, new ID: {new_tv_id}")
    
    return jsonify({
        'success': True,
        'new_tv_id': new_tv_id,
        'qr_code': qr_base64
    })

@app.route('/api/update-match', methods=['POST'])
def update_match():
    """API endpoint for iPhone app to update match data"""
    print(f"📱 Received update request from iPhone app")
    data = request.get_json()
    print(f"📱 Request data: {data}")
    
    tv_id = data.get('tv_id')
    print(f"📱 TV ID: {tv_id}")
    
    if not tv_id or tv_id not in tv_sessions:
        print(f"❌ Invalid TV ID: {tv_id}")
        return jsonify({'success': False, 'error': 'Invalid TV ID'}), 400
    
    tv_session = tv_sessions[tv_id]
    match_id = tv_session.get('linked_match_id')
    
    if not match_id:
        print(f"❌ No match linked to TV: {tv_id}")
        return jsonify({'success': False, 'error': 'No match linked to this TV'}), 400
    
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
    
    # Add set scores
    for i in range(1, match.best_of_sets + 1):
        update_data[f'team1_set{i}_games'] = match.team1_set_games.get(i, 0)
        update_data[f'team2_set{i}_games'] = match.team2_set_games.get(i, 0)
    
    # Emit update to the specific TV
    socketio.emit('match_update', update_data, room=tv_id)
    
    print(f"✅ Successfully updated match {match_id} via TV {tv_id}")
    
    return jsonify({'success': True})

@socketio.on('join')
def on_join(data):
    """Handle TV display joining a match room"""
    tv_id = data['tv_id']
    join_room(tv_id)
    print(f"TV display joined room: {tv_id}")

@socketio.on('disconnect')
def on_disconnect():
    """Handle TV display disconnection"""
    print("TV display disconnected")

@app.route('/api/match-status/<tv_id>')
def match_status(tv_id):
    """Get current match status for a specific TV"""
    if tv_id not in tv_sessions:
        return jsonify({'success': False, 'error': 'Invalid TV ID'}), 400
    
    tv_session = tv_sessions[tv_id]
    match_id = tv_session.get('linked_match_id')
    
    if not match_id:
        return jsonify({'success': False, 'error': 'No match linked to this TV'}), 400
    
    match = active_matches.get(match_id)
    if not match:
        return jsonify({'success': False, 'error': 'Match not found'}), 404
    
    # Convert scores to tennis format for display
    team1_display_score = convert_tennis_score(match.team1_game_score)
    team2_display_score = convert_tennis_score(match.team2_game_score)
    
    # Build dynamic match data
    match_data = {
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
    
    # Add dynamic set data - include all sets that have been played
    max_sets_played = max(match.best_of_sets, max(match.team1_set_games.keys(), default=0), max(match.team2_set_games.keys(), default=0))
    for i in range(1, max_sets_played + 1):
        match_data[f'team1_set{i}_games'] = match.team1_set_games.get(i, 0)
        match_data[f'team2_set{i}_games'] = match.team2_set_games.get(i, 0)
    
    # Add the actual number of sets being displayed
    match_data['total_sets_displayed'] = max_sets_played
    
    return jsonify({
        'success': True,
        'match': match_data
    })

# Cleanup old matches and TV sessions (older than 24 hours)
def cleanup_old_sessions():
    """Remove old matches and TV sessions"""
    while True:
        current_time = datetime.now()
        to_remove_matches = []
        to_remove_tvs = []
        
        # Clean up old matches
        for match_id, match in active_matches.items():
            if (current_time - match.created_at).total_seconds() > 86400:  # 24 hours
                to_remove_matches.append(match_id)
        
        # Clean up old TV sessions
        for tv_id, tv_session in tv_sessions.items():
            if (current_time - tv_session['created_at']).total_seconds() > 86400:  # 24 hours
                to_remove_tvs.append(tv_id)
        
        # Remove old matches
        for match_id in to_remove_matches:
            del active_matches[match_id]
            # Remove from match_codes
            codes_to_remove = [code for code, mid in match_codes.items() if mid == match_id]
            for code in codes_to_remove:
                del match_codes[code]
        
        # Remove old TV sessions
        for tv_id in to_remove_tvs:
            del tv_sessions[tv_id]
        
        if to_remove_matches or to_remove_tvs:
            print(f"Cleaned up {len(to_remove_matches)} old matches and {len(to_remove_tvs)} old TV sessions")
        
        time.sleep(3600)  # Run every hour

# Start cleanup thread
cleanup_thread = threading.Thread(target=cleanup_old_sessions, daemon=True)
cleanup_thread.start()

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    print("🎾 PadelCast QR Code TV Web Server Starting...")
    print(f"📺 TV setup at: http://localhost:{port}/tv")
    print(f"📱 Scan QR codes to link iPhone apps to TVs")
    socketio.run(app, host='0.0.0.0', port=port, debug=False, allow_unsafe_werkzeug=True)
