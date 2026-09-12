# 🚀 Render.com Free Deployment Guide for OmniRoute

## ⚠️ Important Limitations (Free Tier)

| Feature | Free Tier |
|---------|-----------|
| **Hours/month** | 750 (spins down after 15 min inactivity) |
| **Persistent Disk** | ❌ **NOT INCLUDED** (data lost on restart/deploy) |
| **Custom Domain** | ✅ Yes |
| **SSL/HTTPS** | ✅ Automatic |
| **Credit Card** | ❌ Not required |
| **Cold Start** | ~30-60 seconds after idle |

> **Data Persistence**: Free tier has NO persistent storage. Your SQLite database (`storage.sqlite`) will be **lost on every deploy/restart**. For persistence, you need:
> - **Paid Render plan** ($7/mo for 1GB disk)
> - **External database** (Neon PostgreSQL free, Upstash Redis free)
> - **Alternative**: Use Koyeb (free persistent disk) or Railway

---

## 📋 Prerequisites

1. **GitHub account** (for repo hosting)
2. **Render account** → [render.com](https://render.com) → "Get Started Free" → Sign up with GitHub

---

## 🔧 Step-by-Step Deployment

### **Step 1: Push to GitHub**

```bash
# In PowerShell:
cd C:\Users\Admin\.omniroute

# Initialize git if needed
git init
git add .
git commit -m "OmniRoute deployment config"

# Create GitHub repo (via browser or CLI)
# gh repo create omniroute --public --source=. --push
# OR: Go to github.com/new → create repo → push
```

### **Step 2: Connect to Render**

1. Go to [dashboard.render.com](https://dashboard.render.com)
2. Click **"New +"** → **"Web Service"**
3. Connect **GitHub** → Select your `omniroute` repo
4. Render auto-detects `render.yaml` → Click **"Apply"**

### **Step 3: Configure Environment Variables**

In Render Dashboard → Your Service → **Environment** tab:

| Key | Value | Notes |
|-----|-------|-------|
| `STORAGE_ENCRYPTION_KEY` | `ed2a915056a104fac1e352b41f17f5e7b9b1f53449b3b96b5ac72efa95f56a70` | From your .env |
| `OPENAI_API_KEY` | `sk-your-key` | **Required** - at least one provider |
| `ANTHROPIC_API_KEY` | `sk-ant-...` | Optional |
| `GOOGLE_API_KEY` | `...` | Optional |

> **Click "Add Environment Variable" for each** → Save → Auto-redeploys

### **Step 4: Deploy & Test**

1. Render builds Docker image (~2-3 min)
2. Service goes **Live** → URL: `https://omniroute-xxxx.onrender.com`
3. Test health: `https://omniroute-xxxx.onrender.com/health`
4. Test OmniRoute CLI:
```bash
omniroute --base-url https://omniroute-xxxx.onrender.com status
omniroute --base-url https://omniroute-xxxx.onrender.com chat "Hello Render!"
```

---

## 🔑 Using OmniRoute CLI with Render

```bash
# Set base URL for current session
export OMNIROUTE_BASE_URL="https://your-app.onrender.com"

# Or use --base-url flag
omniroute --base-url https://your-app.onrender.com chat "Test"

# Configure CLI to use Render permanently
omniroute config set base-url https://your-app.onrender.com
```

---

## 📊 Monitoring & Logs

| Action | How |
|--------|-----|
| **View Logs** | Render Dashboard → Service → **Logs** tab |
| **Metrics** | Dashboard → **Metrics** (CPU, Memory, Requests) |
| **Manual Deploy** | Dashboard → **Manual Deploy** → **Deploy Latest** |
| **Rollback** | Dashboard → **Deploys** → Click old deploy → **Rollback** |

---

## 💰 Upgrade for Persistence (Optional)

| Plan | Cost | Disk | Always On |
|------|------|------|-----------|
| **Free** | $0 | ❌ None | ❌ Spins down |
| **Starter** | $7/mo | 1 GB | ✅ Yes |
| **Standard** | $25/mo | 10 GB | ✅ Yes |

> For OmniRoute SQLite persistence: **Starter plan ($7/mo)** gives 1GB disk at `/data`

---

## 🔄 Alternative: External Free Database (Keep Free Tier)

Since Render free has no disk, use **external free databases**:

### **Option A: Neon PostgreSQL (Free 3 GB)**
```bash
# 1. Go to neon.tech → Create project → Copy connection string
# 2. In Render env vars:
DATABASE_URL=postgresql://user:pass@ep-xxx.us-east-1.aws.neon.tech/omniroute
# 3. Modify OmniRoute to use PostgreSQL (config change needed)
```

### **Option B: Upstash Redis (Free 10 MB)**
```bash
# 1. Go to upstash.com → Create Redis → Copy URL
# 2. In Render env vars:
REDIS_URL=rediss://user:pass@host:port
```

> ⚠️ Requires OmniRoute config changes to use external DB instead of SQLite.

---

## 🆘 Troubleshooting

| Issue | Fix |
|-------|-----|
| **Build fails** | Check Logs tab → Usually missing dependency or port mismatch |
| **Health check fails** | Ensure `/health` returns 200 → Check `PORT` env var used in CMD |
| **Spins down too fast** | Free tier = 15 min, cannot change. Upgrade or ping externally. |
| **Cold start slow** | Normal for free tier (~30-60s). First request wakes service. |
| **Env vars not working** | Must redeploy after adding (auto-deploys on env change) |
| **Out of hours** | 750 hrs/month = ~25 days 24/7. Service pauses until next month. |

---

## 🎯 Quick Command Reference

```bash
# Local test before deploy
docker build -t omniroute .
docker run -p 20128:20128 -e PORT=20128 -e STORAGE_ENCRYPTION_KEY=xxx omniroute

# Check Render logs locally (if using render CLI)
npm install -g @render/cli
render logs -s omniroute --tail

# Trigger manual deploy
render deploy -s omniroute
```

---

## ✅ Summary

| File | Purpose |
|------|---------|
| `render.yaml` | Infrastructure as code (service config) |
| `Dockerfile` | Container build (OmniRoute 3.8.50) |
| `.dockerignore` | Excludes local data/secrets |
| `RENDER_DEPLOY.md` | This guide |

**Deploy Flow**: Push to GitHub → Render auto-builds → Set env vars → Live!

---

## 🔗 Useful Links

- [Render Free Tier Details](https://render.com/pricing)
- [Render Docker Docs](https://render.com/docs/docker)
- [Render Environment Variables](https://render.com/docs/configure-environment-variables)
- [OmniRoute Config](https://omniroute.io/docs)