# 🚀 Railway Deployment Guide for PadelCast QR Code System

## 🆕 New Project: PadelCast QR Code System

This is a **completely new Railway project** separate from the existing PadelCast system. It implements the new QR code-based TV linking system.

## 🎯 What's New

- **QR Code Generation**: TVs automatically generate unique QR codes
- **iPhone App Scanning**: Apps scan QR codes instead of entering codes
- **Automatic Linking**: Instant connection between TV and iPhone app
- **Post-Match Reset**: Easy reset for new matches with new QR codes

## 🚀 Quick Deploy Steps

### 1. Go to Railway
- Visit [railway.app](https://railway.app)
- Sign in with your GitHub account

### 2. Create New Project
- Click **"New Project"**
- Select **"Deploy from GitHub repo"**
- Choose your repository: `xcode18` (or your repo name)
- **Important**: Set **Root Directory** to `cloud-deployment`

### 3. Configure Settings
- **Root Directory**: `cloud-deployment`
- **Start Command**: `gunicorn --worker-class eventlet -w 1 app:app --bind 0.0.0.0:$PORT`
- **Environment**: Python 3.11 or higher

### 4. Deploy
- Click **"Deploy"**
- Wait 2-3 minutes for deployment
- Railway will provide your URL: `https://your-app-name.railway.app`

## 📱 How the New System Works

### For TV Operators:
1. **Open TV**: Navigate to `https://your-app-name.railway.app/tv`
2. **QR Code Appears**: TV automatically shows unique QR code
3. **Wait for Connection**: TV waits for iPhone app to scan
4. **Automatic Display**: When connected, TV shows scoreboard
5. **Post-Match Reset**: After match ends, choose to reset for next match

### For iPhone App Users:
1. **Open App**: Launch PadelCast iPhone app
2. **Scan QR Code**: Use app's scanner to scan TV's QR code
3. **Configure Match**: Set team names, players, settings
4. **Start Scoring**: Begin match - TV updates automatically
5. **End Match**: Mark match as finished when complete

## 🔧 API Endpoints

### TV Setup
- `GET /` - Main page with TV setup instructions
- `GET /tv` - Generate new TV session and QR code
- `GET /tv/<tv_id>` - Access specific TV display

### TV Linking
- `POST /api/link-tv` - Link iPhone app to TV and create match
- `POST /api/reset-tv/<tv_id>` - Reset TV and generate new QR code

### Match Management
- `POST /api/update-match` - Update match scores (uses TV ID)
- `GET /api/match-status/<tv_id>` - Get match status for specific TV

## 📁 Project Structure

```
cloud-deployment/
├── app.py                          # Main Flask backend with QR system
├── requirements.txt                # Dependencies (includes qrcode[pil])
├── Procfile                        # Railway startup command
├── runtime.txt                     # Python version
└── templates/
    ├── tv_setup.html              # TV setup page with QR code
    ├── tv_qr_display.html         # QR display when no match linked
    ├── tv_display.html            # Scoreboard display (updated)
    └── error.html                 # Error page
```

## 🧪 Testing Your Deployment

1. **Test TV Setup**:
   - Open: `https://your-app-name.railway.app/tv`
   - Verify QR code appears
   - Check TV session ID is displayed

2. **Test API Endpoints**:
   - Test match status: `GET /api/match-status/test-id`
   - Should return 400 error (invalid TV ID)

3. **Test iPhone App Integration**:
   - Scan QR code with app
   - Verify connection and match creation
   - Test score updates

## 🔒 Security Features

- **Unique TV Sessions**: Each TV has unguessable session ID
- **QR Code Expiration**: Codes tied to specific TV sessions
- **Automatic Cleanup**: Old sessions removed after 24 hours
- **Isolated Communication**: Each TV has separate channel

## 🚨 Troubleshooting

### Common Issues

1. **QR Code Not Displaying**
   - Check if `qrcode[pil]` is installed
   - Verify Flask server is running
   - Check Railway logs for errors

2. **Deployment Fails**
   - Ensure root directory is set to `cloud-deployment`
   - Check Python version compatibility
   - Verify all dependencies in requirements.txt

3. **Connection Issues**
   - Ensure TV and iPhone are on same network
   - Check Railway logs for connection errors
   - Verify TV session is still active

### Debug Mode

To enable debug logging, modify `app.py`:
```python
socketio.run(app, host='0.0.0.0', port=port, debug=True, allow_unsafe_werkzeug=True)
```

## 💰 Free Tier Limits

- **Railway**: $5 credit monthly (sufficient for testing)
- **Usage**: Minimal resource consumption
- **Uptime**: 24/7 availability

## 🔄 Migration from Old System

If you're upgrading from the old code-based system:

1. **Update iPhone App**: Modify to scan QR codes instead of generating codes
2. **Update API Calls**: Change from `code` parameter to `tv_id` parameter
3. **Test New Flow**: Verify QR code scanning and linking works
4. **Deploy Both**: Keep old system running while testing new one

## 🎉 Benefits of New System

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

## 📞 Support

For issues with the new QR code system:
1. Check Railway deployment logs
2. Verify all dependencies are installed
3. Test with the provided endpoints
4. Check network connectivity

## 🚀 Next Steps

1. **Deploy to Railway** using this guide
2. **Test the system** with TV and iPhone app
3. **Update iPhone app** to work with new system
4. **Share with users** and gather feedback
5. **Scale up** if needed for production use

---

**🎾 Welcome to the future of PadelCast! The QR code system makes connecting TVs and iPhone apps effortless and secure.**
