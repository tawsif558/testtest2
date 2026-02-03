#!/bin/bash

echo "🛑 Stopping everything..."

# Save world files to workspace backup
echo "💾 Backing up world saves..."
mkdir -p /workspaces/valheim-backup 2>/dev/null

# Try to backup from Docker container
if docker ps | grep -q valheim; then
    echo "📦 Saving world from Docker container..."
    
    # Create a manual save in the game console (if accessible)
    # This depends on the Docker image having console access
    docker exec valheim_server bash -c 'echo "save" > /tmp/save.command 2>/dev/null' || true
    
    # Wait for save to complete
    sleep 5
    
    # Backup the actual files
    docker cp valheim_valheim_1:/config/. /workspaces/valheim-backup/ 2>/dev/null || \
    docker cp valheim:/config/. /workspaces/valheim-backup/ 2>/dev/null || \
    echo "⚠️ Could not backup from Docker, but volumes will persist"
    
    echo "✅ World backup saved to /workspaces/valheim-backup/"
fi

# Stop Valheim server gracefully
echo "🛡️ Stopping Valheim server gracefully..."
cd /workspaces/valheim 2>/dev/null

# Use docker-compose stop with timeout for graceful shutdown
if [ -f "docker-compose.yml" ]; then
    docker-compose stop -t 60 valheim
    sleep 2
    docker-compose down
else
    docker stop valheim 2>/dev/null
    docker rm -f valheim 2>/dev/null
fi

# Stop PlayIt tunnel
echo "🌐 Stopping PlayIt tunnel..."
pkill -f playit 2>/dev/null
sleep 2

# Double-check PlayIt is stopped
pkill -9 -f playit 2>/dev/null

# Kill any remaining processes
pkill -f valheim 2>/dev/null

echo ""
echo "✅ All services stopped!"
echo "💾 World files are preserved in:"
echo "   - Docker volumes (persistent)"
echo "   - /workspaces/valheim-backup/ (manual backup)"

echo ""
echo "📊 Quick status check:"
docker ps 2>/dev/null | grep -E "valheim|SERVER" || echo "✅ No Docker containers running"
ps aux 2>/dev/null | grep -E "playit|valheim" | grep -v grep || echo "✅ No processes running"
