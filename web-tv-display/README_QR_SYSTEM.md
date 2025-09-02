# PadelCast QR Code TV Linking System

## Overview

The PadelCast system has been redesigned to use a **QR code-based linking system** instead of manually generated codes. This new approach provides better security, user experience, and eliminates the need for manual code entry.

## How It Works

### 1. TV Display Setup
- **TV opens**: Navigate to `/tv` on any TV display
- **QR Code Generation**: Each TV automatically generates a unique QR code
- **Unique Session**: Each TV gets a unique session ID for security

### 2. iPhone App Connection
- **Scan QR Code**: iPhone app scans the QR code displayed on TV
- **Automatic Linking**: App automatically connects to the specific TV
- **Match Configuration**: User configures match settings in the app
- **Instant Connection**: TV automatically switches to scoreboard display

### 3. Match Management
- **Real-time Updates**: Score updates are sent directly to the linked TV
- **Secure Communication**: Each TV has its own secure communication channel
- **Automatic Cleanup**: Old sessions are automatically cleaned up

### 4. Post-Match Reset
- **Match End**: When match finishes, TV shows reset option
- **New QR Code**: User can generate new QR code for next match
- **Clean Slate**: Fresh start for each new match

## New API Endpoints

### TV Setup
- `GET /tv` - Generate new TV session and QR code
- `GET /tv/<tv_id>` - Access specific TV display

### TV Linking
- `POST /api/link-tv` - Link iPhone app to TV and create match
- `POST /api/reset-tv/<tv_id>` - Reset TV and generate new QR code

### Match Management
- `POST /api/update-match` - Update match scores (now uses TV ID)
- `GET /api/match-status/<tv_id>` - Get match status for specific TV

## File Structure

```
web-tv-display/
├── app.py                          # Main Flask backend with QR system
├── templates/
│   ├── tv_setup.html              # TV setup page with QR code
│   ├── tv_qr_display.html         # QR display when no match linked
│   ├── tv_display.html            # Scoreboard display (updated)
│   └── error.html                 # Error page
├── requirements.txt                # Dependencies (includes qrcode)
└── test_qr_system.py              # Test script for new system
```

## Installation

1. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Start Server**:
   ```bash
   python app.py
   ```

3. **Access TV Setup**:
   - Open browser on TV: `http://localhost:8080/tv`
   - QR code will be automatically generated

## Usage Flow

### For TV Operators
1. **Open TV Display**: Navigate to `/tv` on any TV
2. **Display QR Code**: TV shows QR code and waits for connection
3. **Automatic Connection**: When iPhone app scans, TV automatically connects
4. **Scoreboard Display**: TV shows live scoreboard during match
5. **Post-Match Reset**: After match ends, choose to reset or keep current

### For iPhone App Users
1. **Open App**: Launch PadelCast iPhone app
2. **Scan QR Code**: Use app's scanner to scan TV's QR code
3. **Configure Match**: Set team names, players, match settings
4. **Start Match**: Begin scoring - TV updates automatically
5. **End Match**: Mark match as finished when complete

## Security Features

- **Unique TV Sessions**: Each TV has a unique, unguessable session ID
- **QR Code Expiration**: QR codes are tied to specific TV sessions
- **Automatic Cleanup**: Old sessions are automatically removed after 24 hours
- **Isolated Communication**: Each TV has its own communication channel

## Benefits of New System

### ✅ **Improved Security**
- No more guessable codes
- Each TV has unique, secure session
- Automatic session expiration

### ✅ **Better User Experience**
- No manual code entry required
- Instant connection via QR scan
- Automatic TV switching

### ✅ **Simplified Workflow**
- TV operators just open the page
- iPhone users just scan and configure
- No coordination of codes needed

### ✅ **Scalability**
- Multiple TVs can run simultaneously
- Each TV operates independently
- No conflicts between different matches

## Testing

Run the test script to verify the system:

```bash
python test_qr_system.py
```

This will test:
- TV setup functionality
- API endpoint validation
- Basic system connectivity

## Troubleshooting

### Common Issues

1. **QR Code Not Displaying**
   - Check if `qrcode[pil]` is installed
   - Verify Flask server is running
   - Check browser console for errors

2. **Connection Fails**
   - Ensure TV and iPhone are on same network
   - Check server logs for connection errors
   - Verify TV session is still active

3. **Match Updates Not Showing**
   - Check if TV is properly linked to match
   - Verify WebSocket connection is active
   - Check server logs for update errors

### Debug Mode

Enable debug logging in `app.py`:
```python
socketio.run(app, host='0.0.0.0', port=port, debug=True, allow_unsafe_werkzeug=True)
```

## Migration from Old System

If you're upgrading from the old code-based system:

1. **Update iPhone App**: Modify app to scan QR codes instead of generating codes
2. **Update API Calls**: Change from using `code` parameter to `tv_id` parameter
3. **Test New Flow**: Verify QR code scanning and linking works correctly
4. **Deploy**: Update both backend and frontend components

## Future Enhancements

- **QR Code Refresh**: Automatic QR code rotation for security
- **Multi-TV Management**: Dashboard for managing multiple TVs
- **Advanced Analytics**: Track TV usage and connection patterns
- **Mobile TV App**: Dedicated TV app instead of web browser

## Support

For issues or questions about the new QR code system:
1. Check server logs for error messages
2. Verify all dependencies are installed
3. Test with the provided test script
4. Check network connectivity between devices
