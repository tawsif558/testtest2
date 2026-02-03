#!/bin/bash
echo "🚀 Starting Valheim server..."
docker-compose up -d valheim
sleep 5
echo "✅ Server started!"
echo ""
echo "📌 Connection Info:"
echo "   Local connection: localhost:2456"
echo "   Password: codespace123"
echo "   World: CodespaceWorld"
echo ""
echo "📋 Commands:"
echo "   View logs: docker-compose logs -f"
echo "   Stop: ./stop.sh"
