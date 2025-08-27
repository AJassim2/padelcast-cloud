# 🎾 PadelCast TV Web Display

A web-based TV display system for PadelCast that allows you to stream match scores to any TV with a web browser.

## 🚀 Features

- **Unique Match Codes**: Generate 6-character codes for each match
- **Real-time Updates**: Live score updates via WebSocket
- **Beautiful TV Interface**: Full-screen, TV-optimized display
- **Cross-platform**: Works on any device with a web browser
- **No App Required**: Just open a web browser on your TV

## 📋 Requirements

- Python 3.7+
- Flask and Flask-SocketIO
- Network access (same WiFi network as your iPhone)

## 🛠️ Installation

1. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Run the web server:**
   ```bash
   python app.py
   ```

3. **Access the web interface:**
   - Open your browser and go to: `http://localhost:5000`
   - Or on your network: `http://YOUR_COMPUTER_IP:5000`

## 📱 How to Use

### Step 1: Generate a Match Code
1. Open the web interface in your browser
2. Enter Team 1 and Team 2 names
3. Click "Generate TV Code"
4. You'll get a unique 6-character code (e.g., "ABC123")

### Step 2: Display on TV
1. Open your TV's web browser
2. Go to: `http://YOUR_COMPUTER_IP:5000/tv/ABC123`
3. The TV will show a beautiful match display

### Step 3: Connect iPhone App
1. Enter the code in your iPhone app
2. Start scoring - updates appear instantly on TV!

## 🌐 Network Setup

### Find Your Computer's IP Address:
- **Mac/Linux**: Run `ifconfig` in terminal
- **Windows**: Run `ipconfig` in command prompt
- Look for your local IP (usually starts with 192.168.x.x or 10.0.x.x)

### Make Sure Devices Are on Same Network:
- Your computer running the web server
- Your iPhone with the PadelCast app
- Your TV with web browser
- All must be on the same WiFi network

## 📺 TV Browser Compatibility

Works with most modern TV browsers:
- **Samsung Smart TV** (2018+)
- **LG Smart TV** (webOS)
- **Sony Smart TV** (Android TV)
- **Fire TV Stick** (Silk browser)
- **Apple TV** (Safari)
- **Chromecast** (Google TV)

## 🔧 Technical Details

- **Backend**: Flask with Flask-SocketIO
- **Frontend**: HTML5, CSS3, JavaScript
- **Real-time**: WebSocket connections
- **Port**: 5000 (configurable)
- **Auto-cleanup**: Old matches removed after 24 hours

## 🚨 Troubleshooting

### TV Can't Connect:
1. Check if computer and TV are on same WiFi
2. Verify firewall allows port 5000
3. Try accessing from phone browser first

### No Updates on TV:
1. Check iPhone app has correct code
2. Verify web server is running
3. Check browser console for errors

### Code Not Working:
1. Generate a new code
2. Make sure code is entered correctly
3. Check server logs for errors

## 📞 Support

If you encounter issues:
1. Check the server console for error messages
2. Verify all devices are on the same network
3. Try refreshing the TV browser page

---

**🎾 Enjoy your PadelCast matches on the big screen!**
