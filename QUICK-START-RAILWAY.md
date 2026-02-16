# 🚀 QUICK START - Railway Auto Deploy

Everything is ready! Choose your method:

---

## ⚡ Method 1: Automatic (Recommended if you have Railway CLI)

### Install Railway CLI (if not installed):
```powershell
npm i -g @railway/cli
```

### Login and Link:
```powershell
railway login
railway link
```

### Run Auto-Deploy:
```powershell
.\railway-auto-deploy.ps1
```

**This will:**
- ✅ Set all environment variables
- ✅ Commit and push code
- ✅ Deploy to Railway automatically

---

## 📋 Method 2: Manual (If no Railway CLI)

### Step 1: Copy Environment Variables

Open [.env.railway](.env.railway) file and copy ALL lines.

### Step 2: Paste in Railway Dashboard

1. Go to https://railway.app
2. Click your project
3. Click on your **web service** (not the MySQL service)
4. Click **"Variables"** tab
5. Click **"Raw Editor"** (top right)
6. Paste all variables from `.env.railway`
7. **Important:** Update `APP_URL` with your actual Railway URL
8. Click **"Update Variables"**

### Step 3: Deploy Code

```powershell
git add .
git commit -m "Fix Railway 500 error"
git push
```

Railway will automatically redeploy.

---

## 🎯 What's Included

All files are ready:
- ✅ **config/database.php** - Fixed to support Railway MySQL
- ✅ **nixpacks.toml** - Optimized deployment script
- ✅ **.env.railway** - All environment variables
- ✅ **railway-auto-deploy.ps1** - Auto-setup script

---

## 📝 After Deployment

### 1. Check Deployment Status
```powershell
railway status
```

### 2. View Logs
```powershell
railway logs
```

### 3. Seed Database (First Time Only)
```powershell
railway run php artisan db:seed
```

Or visit: `https://your-app-url.up.railway.app/seed-once` (create this route temporarily)

---

## ❓ Troubleshooting

### "Railway CLI not found"
- Install it: `npm i -g @railway/cli`

### "Not linked to project"
- Run: `railway link`
- Select your project

### "Still getting 500 error"
1. Check Railway logs: `railway logs`
2. Verify APP_KEY is set: `railway variables`
3. Verify MySQL service is running in Railway dashboard
4. Check [RAILWAY-500-ERROR-FIX.md](RAILWAY-500-ERROR-FIX.md) for detailed troubleshooting

---

## ✨ What Was Fixed

- ✅ Database defaults to MySQL (not SQLite)
- ✅ Supports Railway's MYSQLHOST variables
- ✅ Removed auto-seeding from deployment
- ✅ Storage directories created properly
- ✅ All environment variables ready to use

---

**Ready? Run:** `.\railway-auto-deploy.ps1`

Or manually copy-paste from `.env.railway` to Railway Dashboard!
