const express = require('express');
const path    = require('path');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(express.static(__dirname));

app.post('/api/notify', async (req, res) => {
  const { restaurant, address, cuisine } = req.body;
  const token  = process.env.TELEGRAM_BOT_TOKEN;
  const chatId = process.env.TELEGRAM_CHAT_ID;

  if (!token || !chatId) return res.status(500).json({ error: 'Telegram not configured' });

  const text =
    `🌸 <b>Она выбрала!</b>\n\n` +
    `🍴 Кухня: ${cuisine}\n` +
    `🏠 Ресторан: <b>${restaurant}</b>\n` +
    `📍 Адрес: ${address}\n\n` +
    `✨ Удачного свидания!`;

  try {
    const r = await fetch(`https://api.telegram.org/bot${token}/sendMessage`, {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify({ chat_id: chatId, text, parse_mode: 'HTML' }),
    });
    const data = await r.json();
    res.json({ ok: data.ok });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

const PORT = process.env.PORT || 3100;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Server running → http://localhost:${PORT}`);
});
