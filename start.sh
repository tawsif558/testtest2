#!/bin/bash

echo "🚀 Starting Valheim Server & PlayIt Tunnel..."

# Check if PlayIt is installed
if ! command -v playit &> /dev/null; then
    echo "❌ PlayIt not found! Installing now..."
    curl -SsL https://playit.gg/install.sh | bash
fi

# Start Valheim server
echo "🛡️ Starting Valheim server..."
cd /workspaces/valheim
docker-compose up -d

# Wait for server to initialize
echo "⏳ Waiting for server to start (30 seconds)..."
sleep 30

# Check if server is running
if ! docker ps | grep -q valheim; then
    echo "❌ Valheim server failed to start. Check logs with: docker-compose logs"
    exit 1
fi

# Start PlayIt tunnel
echo "🌐 Starting PlayIt tunnel..."
echo ""
echo "=================================================="
echo "           IMPORTANT: PLAYIT SETUP"
echo "=================================================="
echo ""
echo "PlayIt will show a URL like:"
echo "    https://playit.gg/claim?code=XXXXX-XXXXX"
echo ""
echo "TO GET PUBLIC SERVER ADDRESS:"
echo "1. Copy the URL above"
echo "2. Open it in your browser"
echo "3. Follow the instructions"
echo "4. You'll get an address like: XXXXX.playit.gg:XXXXX"
echo "5. Share that address with friends"
echo ""
echo "=================================================="
echo ""

# Start PlayIt in a way that shows output but doesn't block
# Using screen to keep it running
if command -v screen &> /dev/null; then
    echo "📺 Starting PlayIt in screen session..."
    screen -dmS playit-tunnel bash -c "playit; exec bash"
    sleep 3
    echo "✅ PlayIt started in screen session."
    echo "To view PlayIt output: screen -r playit-tunnel"
    echo "To detach from screen: Ctrl+A then D"
else
    echo "📝 Starting PlayIt in background..."
    nohup playit > /tmp/playit.log 2>&1 &
    PLAYIT_PID=$!
    echo $PLAYIT_PID > /tmp/playit.pid
    sleep 5
    echo "✅ PlayIt started (PID: $PLAYIT_PID)"
    echo "View logs: tail -f /tmp/playit.log"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📌 Valheim Server Info:"
echo "   Local Connection: localhost:2456"
echo "   Password: codespace123"
echo "   World Name: CodespaceWorld"
echo ""
echo "🌐 To get public address for friends, check PlayIt output above"
echo ""
echo "📋 Quick commands:"
echo "   Stop everything: ./stop.sh"
echo "   View Valheim logs: docker-compose logs -f"
echo "   View PlayIt logs: tail -f /tmp/playit.log"
