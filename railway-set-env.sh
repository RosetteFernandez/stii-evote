#!/bin/bash
# Railway Environment Variables - Bulk Upload Script

echo "=========================================="
echo "Railway Environment Setup"
echo "=========================================="
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null
then
    echo "❌ Railway CLI not found!"
    echo ""
    echo "Install it first:"
    echo "  npm i -g @railway/cli"
    echo ""
    echo "Then login:"
    echo "  railway login"
    echo ""
    echo "Then link your project:"
    echo "  railway link"
    echo ""
    exit 1
fi

echo "✅ Railway CLI found!"
echo ""

# Check if project is linked
if ! railway status &> /dev/null
then
    echo "❌ Not linked to a Railway project!"
    echo ""
    echo "Link your project first:"
    echo "  railway link"
    echo ""
    exit 1
fi

echo "✅ Project linked!"
echo ""
echo "Setting environment variables..."
echo ""

# Set all variables
railway variables set APP_NAME="STII E-Vote System"
railway variables set APP_ENV=production
railway variables set APP_KEY="base64:rxbdTW/mv+EjdOr4hotCYPmJ4RajnymeUS/Jy12mUgM="
railway variables set APP_DEBUG=false
railway variables set APP_TIMEZONE=Asia/Manila

railway variables set DB_CONNECTION=mysql

railway variables set SESSION_DRIVER=database
railway variables set SESSION_LIFETIME=120
railway variables set SESSION_ENCRYPT=false
railway variables set CACHE_STORE=database
railway variables set QUEUE_CONNECTION=database

railway variables set FILESYSTEM_DISK=public

railway variables set LOG_CHANNEL=stack
railway variables set LOG_LEVEL=error

railway variables set MAIL_MAILER=smtp
railway variables set MAIL_HOST=smtp.gmail.com
railway variables set MAIL_PORT=587
railway variables set MAIL_USERNAME=rthrcapistrano@gmail.com
railway variables set MAIL_PASSWORD="kdfg lelx egxd sjwk"
railway variables set MAIL_ENCRYPTION=tls
railway variables set MAIL_FROM_ADDRESS=rthrcapistrano@gmail.com
railway variables set MAIL_FROM_NAME="STII E-Vote System"

echo ""
echo "=========================================="
echo "✅ All variables set!"
echo "=========================================="
echo ""
echo "Railway will automatically redeploy."
echo ""
echo "Check status:"
echo "  railway status"
echo ""
echo "View logs:"
echo "  railway logs"
echo ""
