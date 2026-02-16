#!/bin/bash
# Quick Deploy to Railway - Fix 500 Error

echo "======================================"
echo "Railway 500 Error Fix - Quick Deploy"
echo "======================================"
echo ""

echo "📦 Adding changes to git..."
git add config/database.php nixpacks.toml RAILWAY-500-ERROR-FIX.md

echo "✅ Committing changes..."
git commit -m "Fix Railway 500 error: Update database config and deployment process

- Changed default DB connection from sqlite to mysql
- Added support for Railway MYSQL* environment variables
- Optimized deployment script (removed auto-seeding)
- Created storage directories before setting permissions
- Added comprehensive fix documentation"

echo "🚀 Pushing to Railway..."
git push

echo ""
echo "======================================"
echo "✅ Deploy initiated!"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. Go to Railway Dashboard and check deployment logs"
echo "2. Verify these environment variables are set:"
echo "   - APP_KEY"
echo "   - DB_CONNECTION=mysql"
echo "   - APP_URL (your Railway URL)"
echo ""
echo "3. If this is first deployment, seed database:"
echo "   railway run php artisan db:seed"
echo ""
echo "See RAILWAY-500-ERROR-FIX.md for complete guide"
echo "======================================"
