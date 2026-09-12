# OmniRoute on Render

OmniRoute — Smart AI Router with Auto Fallback, deployed on Render.com free tier.

## 🚀 Quick Deploy

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/dhruvin019/OmniRoute)

## 📁 Project Structure

```
.
├── render.yaml          # Render service configuration
├── Dockerfile           # Container definition (Node 20 + OmniRoute 3.8.50)
├── .dockerignore        # Excludes local data/secrets
├── RENDER_DEPLOY.md     # Full deployment guide
└── .env                 # Local config (NOT deployed - use Render secrets)
```

## ⚙️ Configuration

Set these environment variables in **Render Dashboard → Environment**:

| Variable | Required | Description |
|----------|----------|-------------|
| `STORAGE_ENCRYPTION_KEY` | ✅ Yes | 64-char encryption key for data |
| `OPENAI_API_KEY` | ✅ Yes* | OpenAI API key |
| `ANTHROPIC_API_KEY` | No | Anthropic API key |
| `GOOGLE_API_KEY` | No | Google AI API key |

*At least one provider key required.

## 🌐 After Deploy

Your OmniRoute server will be available at:
- **API**: `https://your-app.onrender.com`
- **Health**: `https://your-app.onrender.com/health`
- **Dashboard**: `https://your-app.onrender.com/dashboard`

## 💻 Using OmniRoute CLI

```bash
# Configure once
omniroute config set base-url https://your-app.onrender.com

# Or use per-command
omniroute --base-url https://your-app.onrender.com chat "Hello!"

# Check status
omniroute --base-url https://your-app.onrender.com status
```

## ⚠️ Free Tier Limitations

- **750 hours/month** (spins down after 15 min inactivity)
- **No persistent disk** — SQLite data lost on restart/deploy
- **Cold starts** ~30-60s after idle

For persistence: upgrade to Render Starter ($7/mo) or use external DB (Neon, Upstash).

## 📖 Full Guide

See [RENDER_DEPLOY.md](RENDER_DEPLOY.md) for detailed instructions, troubleshooting, and alternatives.

---

**OmniRoute Version**: 3.8.50  
**Node Version**: 20 (Alpine)