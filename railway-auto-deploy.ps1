# Railway Auto-Deploy Script
# This sets all variables and deploys your app

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Railway Auto Setup & Deploy" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Railway CLI is installed
if (!(Get-Command railway -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Railway CLI not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Option 1: Install Railway CLI" -ForegroundColor Yellow
    Write-Host "  npm i -g @railway/cli"
    Write-Host ""
    Write-Host "Option 2: Set variables manually in Railway Dashboard" -ForegroundColor Yellow
    Write-Host "  1. Go to https://railway.app"
    Write-Host "  2. Click your project"
    Write-Host "  3. Click 'Variables' tab"
    Write-Host "  4. Copy-paste from .env.railway file"
    Write-Host ""
    pause
    exit 1
}

Write-Host "✅ Railway CLI found!" -ForegroundColor Green
Write-Host ""

# Check if project is linked
try {
    railway status | Out-Null
    Write-Host "✅ Project linked!" -ForegroundColor Green
} catch {
    Write-Host "❌ Not linked to Railway project!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Run: railway link" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
Write-Host "Setting environment variables..." -ForegroundColor Yellow
Write-Host ""

# Set all variables
$variables = @{
    "APP_NAME" = '"STII E-Vote System"'
    "APP_ENV" = "production"
    "APP_KEY" = "base64:rxbdTW/mv+EjdOr4hotCYPmJ4RajnymeUS/Jy12mUgM="
    "APP_DEBUG" = "false"
    "APP_TIMEZONE" = "Asia/Manila"
    "DB_CONNECTION" = "mysql"
    "SESSION_DRIVER" = "database"
    "SESSION_LIFETIME" = "120"
    "SESSION_ENCRYPT" = "false"
    "CACHE_STORE" = "database"
    "QUEUE_CONNECTION" = "database"
    "FILESYSTEM_DISK" = "public"
    "LOG_CHANNEL" = "stack"
    "LOG_LEVEL" = "error"
    "MAIL_MAILER" = "smtp"
    "MAIL_HOST" = "smtp.gmail.com"
    "MAIL_PORT" = "587"
    "MAIL_USERNAME" = "rthrcapistrano@gmail.com"
    "MAIL_PASSWORD" = '"kdfg lelx egxd sjwk"'
    "MAIL_ENCRYPTION" = "tls"
    "MAIL_FROM_ADDRESS" = "rthrcapistrano@gmail.com"
    "MAIL_FROM_NAME" = '"STII E-Vote System"'
}

foreach ($key in $variables.Keys) {
    Write-Host "  Setting $key..." -ForegroundColor Gray
    railway variables set "$key=$($variables[$key])"
}

Write-Host ""
Write-Host "✅ All variables set!" -ForegroundColor Green
Write-Host ""

# Commit and push changes
Write-Host "Committing and pushing code changes..." -ForegroundColor Yellow
git add config/database.php nixpacks.toml .env.railway
git commit -m "Fix Railway 500 error - database config and environment setup"
git push

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "✅ Deploy Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Check Railway dashboard for deployment status"
Write-Host "2. View logs: railway logs"
Write-Host "3. Seed database (first time only): railway run php artisan db:seed"
Write-Host ""
Write-Host "Your app URL will be in Railway dashboard" -ForegroundColor Cyan
Write-Host ""
