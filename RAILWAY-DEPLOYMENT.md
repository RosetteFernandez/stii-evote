# Railway Deployment Guide for STII E-Vote System

## Quick Setup

### 1. Add MySQL Database to Railway

1. Go to your Railway project dashboard
2. Click **"New"** → **"Database"** → **"Add MySQL"**
3. Railway will automatically create and connect the database

### 2. Set Environment Variables

Go to your Railway project → **Variables** tab → Add these variables:

```env
APP_NAME="STII E-Vote System"
APP_ENV=production
APP_KEY=base64:bQZN73yIjdTjpDs0y97o/BcqrF7TR8uRg28YSl49OzA=
APP_DEBUG=false
APP_URL=https://stiievote-production.up.railway.app
APP_TIMEZONE=Asia/Manila

# Session Configuration
SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=true
SESSION_SECURE_COOKIES=true

# Cache & Queue
CACHE_STORE=database
QUEUE_CONNECTION=database

# Logging
LOG_CHANNEL=stack
LOG_LEVEL=error

# Email (Gmail SMTP)
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=rthrcapistrano@gmail.com
MAIL_PASSWORD=kdfg lelx egxd sjwk
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=rthrcapistrano@gmail.com
MAIL_FROM_NAME="STII E-Vote System"

# Voting Settings
ALLOW_STUDENT_REGISTRATION=true
ALLOW_CANDIDATE_REGISTRATION=true
VOTING_SESSION_TIMEOUT=30
MAX_CANDIDATES_PER_POSITION=10
SHOW_RESULTS_IMMEDIATELY=true
```

**Note:** You do NOT need to set DB_HOST, DB_PORT, etc. Railway automatically injects these when you add the MySQL service:
- `MYSQLHOST`
- `MYSQLPORT`
- `MYSQLDATABASE`
- `MYSQLUSER`
- `MYSQLPASSWORD`

### 3. Deploy

Railway will automatically:
- Install PHP dependencies
- Run migrations
- Seed the database
- Start your application

### 4. Access Your App

Your app will be available at: `https://stiievote-production.up.railway.app`

## Important Notes

- ✅ HTTPS is automatically enforced in production
- ✅ Mixed content errors are fixed
- ✅ Database migrations run automatically on deploy
- ✅ All assets will load via HTTPS

## Troubleshooting

### If deployment fails:
1. Check the Railway logs for specific errors
2. Verify all environment variables are set correctly
3. Ensure MySQL service is added and running

### If you need to run commands manually:
Railway doesn't have a traditional terminal, but you can:
- Add commands to the `nixpacks.toml` deploy phase
- Use Railway CLI: `railway run php artisan <command>`

## Why Not InfinityFree Database?

InfinityFree blocks external database connections. Their MySQL servers (sql300.infinityfree.com, etc.) can only be accessed from within InfinityFree's hosting environment. This is a security restriction they enforce.

## Two Separate Environments

You now have:
1. **InfinityFree**: Uses `sql300.infinityfree.com` database
2. **Railway**: Uses Railway's MySQL database (separate data)

If you need to sync data between them, you'll need to export/import SQL dumps manually.
