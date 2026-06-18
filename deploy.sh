#!/bin/bash
set -e

echo "🚀 Деплой dating-invite..."

git pull origin master

if [ ! -f .env ]; then
  cp .env.example .env
  echo "⚠️  Создан .env — заполни TELEGRAM_BOT_TOKEN и TELEGRAM_CHAT_ID"
  exit 1
fi

if command -v docker &>/dev/null; then
  echo "🐳 Запуск через Docker..."
  docker compose down --remove-orphans
  docker compose build --no-cache
  docker compose up -d
  echo "✅ Готово! http://localhost:3100"
else
  echo "📦 Docker не найден — запуск через Node.js..."

  if ! command -v node &>/dev/null; then
    echo "⬇️  Устанавливаю Node.js 20..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
  fi

  npm install --production

  if ! command -v pm2 &>/dev/null; then
    echo "⬇️  Устанавливаю pm2..."
    npm install -g pm2
  fi

  pm2 stop dating-invite 2>/dev/null || true
  pm2 start server.js --name dating-invite
  pm2 save

  echo "✅ Готово! http://localhost:3100"
  echo "📋 Логи: pm2 logs dating-invite"
fi
