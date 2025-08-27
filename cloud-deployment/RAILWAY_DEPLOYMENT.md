# 🚀 Railway Deployment Guide for PadelCast

## Quick Deploy Steps

### 1. Go to Railway
- Visit [railway.app](https://railway.app)
- Sign in with your GitHub account

### 2. Create New Project
- Click **"New Project"**
- Select **"Deploy from GitHub repo"**
- Choose: `AJassim2/padelcast-cloud`

### 3. Configure Settings
- **Root Directory**: `cloud-deployment`
- **Start Command**: `gunicorn --worker-class eventlet -w 1 app:app --bind 0.0.0.0:$PORT`
- **Environment**: Python 3.11

### 4. Deploy
- Click **"Deploy"**
- Wait 2-3 minutes for deployment

### 5. Get Your URL
- Railway will provide: `https://your-app-name.railway.app`
- This is your cloud server URL!

## Update iPhone App

Once deployed, update your iPhone app:

1. Open **PadelCast** app
2. Go to **TV Code Input**
3. Toggle **"Cloud Service"** to ON
4. Enter your Railway URL: `https://your-app-name.railway.app`
5. Enter team names
6. Click **"Generate Code from Cloud"**
7. Copy the TV URL to your TV browser

## Test Your Cloud Deployment

1. **Generate Code**: Use the iPhone app to generate a code
2. **TV Display**: Open the TV URL on your TV/computer
3. **Score Updates**: Use the iPhone app to update scores
4. **Real-time**: Watch scores update on TV in real-time!

## Troubleshooting

- **Deployment fails**: Check Railway logs for errors
- **App not connecting**: Verify the URL is correct
- **Scores not updating**: Check if SocketIO is working

## Free Tier Limits

- **Railway**: $5 credit monthly (enough for testing)
- **Usage**: Your app will use minimal resources
- **Uptime**: 24/7 availability

## Next Steps

1. Test the cloud deployment
2. Share the app with friends
3. Consider upgrading for production use
