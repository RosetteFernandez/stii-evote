# Railway 500 Error - Complete Fix Guide

## ✅ Changes Applied

### 1. Database Configuration Fixed
- **Changed default connection** from `sqlite` to `mysql` in `config/database.php`
- **Added Railway MySQL variable support**: Now supports both Railway's `MYSQLHOST`, `MYSQLPORT`, etc., and standard Laravel variables

### 2. Deployment Script Optimized
- **Removed db:seed** from deploy phase (can cause failures if data already exists)
- **Added storage directory creation** before setting permissions
- **Reordered commands** for better reliability

---

## 🔑 Required Railway Environment Variables

Go to your Railway project → **Variables** tab and add/verify these:

### Critical Variables (MUST SET)

```env
# Application
APP_NAME="STII E-Vote System"
APP_ENV=production
APP_KEY=base64:rxbdTW/mv+EjdOr4hotCYPmJ4RajnymeUS/Jy12mUgM=
APP_DEBUG=false
APP_URL=https://your-project-name.up.railway.app
APP_TIMEZONE=Asia/Manila

# Database Connection (Railway MySQL auto-provides MYSQLHOST, MYSQLPORT, etc.)
# But we need to specify the connection type
DB_CONNECTION=mysql

# Session & Cache
SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
CACHE_STORE=database
QUEUE_CONNECTION=database

# Filesystem
FILESYSTEM_DISK=public

# Logging
LOG_CHANNEL=stack
LOG_LEVEL=error

# Email Configuration
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=rthrcapistrano@gmail.com
MAIL_PASSWORD="kdfg lelx egxd sjwk"
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=rthrcapistrano@gmail.com
MAIL_FROM_NAME="STII E-Vote System"
```

### Important Notes:

1. **APP_KEY**: Must be set! Use the one from above or generate a new one with `php artisan key:generate --show`

2. **APP_URL**: Change `your-project-name` to your actual Railway app name

3. **Database Variables**: Railway automatically provides:
   - `MYSQLHOST`
   - `MYSQLPORT`
   - `MYSQLDATABASE`
   - `MYSQLUSER`
   - `MYSQLPASSWORD`
   
   You do NOT need to set these manually - just add MySQL service and they're auto-injected!

4. **DB_CONNECTION**: Set this to `mysql` to tell Laravel to use MySQL instead of SQLite

---

## 📋 Step-by-Step Deploy Checklist

### Step 1: Ensure MySQL Database is Added
1. In Railway Dashboard, click **"New"** → **"Database"** → **"Add MySQL"**
2. Wait for it to provision (usually takes 30 seconds)

### Step 2: Set Environment Variables
1. Go to your Railway project
2. Click on your web service
3. Click **"Variables"** tab
4. Copy-paste all variables from above
5. **Most important**: Make sure `APP_KEY` and `DB_CONNECTION=mysql` are set

### Step 3: Deploy Your Code
```bash
git add .
git commit -m "Fix Railway 500 error - database config and deployment"
git push
```

Railway will automatically redeploy.

### Step 4: Verify Deployment
1. Check Railway logs for any errors
2. Visit your app URL
3. If you still see 500 error, check logs for specific error message

---

## 🔍 Troubleshooting

### Still Getting 500 Error?

#### Check Railway Logs:
1. Go to Railway Dashboard
2. Click on your web service
3. Click **"Deployments"** tab
4. Click on the latest deployment
5. Check **"Deploy Logs"** and **"Build Logs"**

#### Common Issues:

**1. "No application encryption key has been specified"**
- Solution: Set `APP_KEY` in Railway variables
- Generate one: `php artisan key:generate --show`

**2. "SQLSTATE[HY000] [2002] Connection refused"**
- Solution: Make sure MySQL service is running in Railway
- Set `DB_CONNECTION=mysql` in variables

**3. "Class 'X' not found"**
- Solution: Missing dependencies or autoload issue
- Check if composer install ran successfully in build logs

**4. Storage permission errors**
- Solution: Already fixed in nixpacks.toml
- Storage directories are now created before setting permissions

**5. "419 Page Expired" or "CSRF token mismatch"**
- Solution: Set `SESSION_DRIVER=database` in Railway variables
- This is because Railway doesn't have persistent filesystem for file-based sessions

---

## 🚀 First Time Seeding Database

Since we removed auto-seeding from deployment (to prevent errors on redeployment), you need to seed manually the first time:

### Option 1: Using Railway CLI
```bash
railway run php artisan db:seed
```

### Option 2: Using Tinker (if no CLI access)
Add this to `routes/web.php` temporarily:
```php
Route::get('/seed-once', function() {
    if (DB::table('users')->count() == 0) {
        Artisan::call('db:seed');
        return 'Database seeded successfully!';
    }
    return 'Database already has data.';
});
```

Visit: `https://your-app.up.railway.app/seed-once`

**Important**: Remove this route after seeding!

---

## ✨ What Was Fixed

### Before:
- ❌ Default database was SQLite (Railway uses MySQL)
- ❌ Database config didn't support Railway's `MYSQLHOST` variables
- ❌ Seeding on every deploy could cause conflicts
- ❌ Storage directories might not exist before chmod

### After:
- ✅ Default database is MySQL
- ✅ Supports both Railway variables and standard Laravel variables
- ✅ Seeding removed from auto-deploy
- ✅ Storage directories created before permissions
- ✅ More robust deployment process

---

## 📞 Need More Help?

If you're still seeing 500 errors after following this guide:

1. Share your Railway deploy logs
2. Check if all environment variables are set
3. Verify MySQL service is running
4. Try accessing `/railway-debug.php` to see diagnostic info

The debug script will show:
- PHP version
- Database connection status
- Storage permissions
- Environment configuration
- Cache status
