#!/bin/sh
set -e
# Run at container start when Railway env (APP_KEY, MYSQLHOST, etc.) is available
php artisan migrate --force --no-interaction 2>/dev/null || true
# Optional: cache config at runtime so env is correct (uncomment if you want caching)
# php artisan config:cache && php artisan route:cache && php artisan view:cache
exec php artisan serve --host=0.0.0.0 --port="${PORT:-8000}"
