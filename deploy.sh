#!/bin/bash
set -e

echo "🚀 Деплой dating-invite..."

# 1. Обновить код
git pull origin main

# 2. Скопировать .env если его нет
if [ ! -f .env ]; then
  cp .env.example .env
  echo "⚠️  Создан .env — заполни TELEGRAM_BOT_TOKEN и TELEGRAM_CHAT_ID"
  exit 1
fi

# 3. Пересобрать и запустить
docker compose down --remove-orphans
docker compose build --no-cache
docker compose up -d

echo "✅ Готово! Сайт доступен на порту 3000"
echo "📋 Логи: docker compose logs -f"
