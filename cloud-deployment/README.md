# 🎾 PadelCast QR Code System - Railway Deployment

## 🆕 New QR Code-Based TV Linking System

This is the **PadelCast QR Code System** - a completely new approach to connecting TVs and iPhone apps using QR codes instead of manually generated codes.

## 🚀 Quick Start

### Deploy to Railway
1. Visit [railway.app](https://railway.app)
2. Create new project from GitHub repo
3. Set root directory to `cloud-deployment`
4. Deploy and get your cloud URL

### Use the System
1. **TV**: Open `/tv` endpoint to show QR code
2. **iPhone App**: Scan QR code to link to TV
3. **Automatic Connection**: TV and app connect instantly
4. **Score Management**: Update scores in real-time
5. **Post-Match Reset**: Generate new QR code for next match

## 📱 How It Works

- **TVs generate unique QR codes** automatically
- **iPhone apps scan QR codes** to establish connection
- **No manual code entry** required
- **Secure, unique sessions** for each TV
- **Automatic cleanup** of old sessions

## 🔧 Technical Details

- **Backend**: Flask + SocketIO with QR code generation
- **Frontend**: Responsive HTML templates with real-time updates
- **Deployment**: Railway with Gunicorn + Eventlet
- **Dependencies**: See `requirements.txt`

## 📚 Documentation

- **Deployment Guide**: [RAILWAY_QR_SYSTEM.md](RAILWAY_QR_SYSTEM.md)
- **API Reference**: See deployment guide for endpoints
- **Troubleshooting**: Common issues and solutions

## 🎯 Benefits

- ✅ **Better Security**: Unique, unguessable TV sessions
- ✅ **Improved UX**: No manual code coordination
- ✅ **Scalability**: Multiple TVs run independently
- ✅ **Easy Reset**: Fresh start for each new match

---

**Ready to deploy? Follow the [Railway Deployment Guide](RAILWAY_QR_SYSTEM.md) to get started!**
