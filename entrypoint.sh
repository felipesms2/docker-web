#!/usr/bin/env bash
set -eu

project_type="${PROJECT_TYPE:-laravel}"

case "$project_type" in
  static|node-static)
    # Apache serves /app for static sites and /app/dist for Node build output.
    exec apache2ctl -D FOREGROUND
    ;;
  laravel)
    cd /app
    chmod -R u+rwX,g+rwX storage bootstrap/cache 2>/dev/null || true

    if [ "${INSTALL_DEPENDENCIES:-true}" = "true" ]; then
      composer install --no-interaction --prefer-dist
    fi

    if [ ! -f .env ] && [ -f .env.example ]; then
      cp .env.example .env
    fi

    if [ -f artisan ] && ! grep -q '^APP_KEY=base64:' .env 2>/dev/null; then
      php artisan key:generate --force
    fi

    exec apache2ctl -D FOREGROUND
    ;;
  *)
    echo "PROJECT_TYPE invalido: $project_type (use laravel, static ou node-static)" >&2
    exit 1
    ;;
esac
