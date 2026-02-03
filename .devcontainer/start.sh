#!/bin/bash

echo "🚀 Starting Valheim Server & PlayIt Tunnel..."

# Start Valheim server
echo "🛡️ Starting Valheim server..."
cd /workspaces/valheim
docker-compose up -d

# Wait for server to initialize
echo "⏳ Waiting for server to start (30 seconds)..."
sleep 30

# Start PlayIt tunnel
echo "🌐 Starting PlayIt tunnel..."
echo ""
echo "=================================================="
echo "IMPORTANT: When PlayIt prompts you with a URL:"
echo "1. Copy the URL that starts with https://playit.gg/claim"
echo "2. Open it in your browser"
echo "3. Follow instructions to get your public server address"
echo "4. Share that address with friends to connect"
echo "=================================================="
echo ""

# Start PlayIt in background and save claim URL to file
nohup playit > /tmp/playit.log 2>&1 &

# Wait a moment for PlayIt to start
sleep 5

# Display initial PlayIt output
echo "📋 PlayIt Output (Check /tmp/playit.log for full logs):"
tail -10 /tmp/playit.log

echo ""
echo "✅ Setup complete!"
echo ""
echo "📌 Valheim Server Info:"
echo "   Local Connection: localhost:2456"
echo "   Password: codespace123"
echo ""
echo "🌐 To get public address for friends:"
echo "   Check PlayIt output above or run:"
echo "   cat /tmp/playit.log | grep -i 'claim\|http'"
echo ""
echo "🛑 To stop everything: ./stop.sh"
