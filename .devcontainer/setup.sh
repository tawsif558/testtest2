#!/bin/bash

echo "🚀 Setting up Valheim development environment..."

# Update system
sudo apt-get update
sudo apt-get install -y \
    wget \
    curl \
    tar \
    libc6-dev \
    screen \
    net-tools

# Install Docker Compose if needed
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create project structure
mkdir -p /workspaces/valheim/{config,data,backups}
cd /workspaces/valheim

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  valheim:
    image: lloesche/valheim-server
    container_name: valheim-server
    ports:
      - "2456-2458:2456-2458/udp"
    volumes:
      - ./config:/config
      - ./data:/opt/valheim
      - ./backups:/backups
    environment:
      - SERVER_NAME=ValheimDevServer
      - WORLD_NAME=CodespaceWorld
      - SERVER_PASS=devpassword123
      - TIMEZONE=UTC
      - UPDATE_CRON="0 3 * * *"
      - BACKUPS_CRON="0 */6 * * *"
      - BACKUPS_MAX_AGE=3
      - RESTART_CRON="0 4 * * *"
    restart: unless-stopped
EOF

echo "✅ Setup complete!"
echo ""
echo "To start the server:"
echo "  docker-compose up -d"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f"
echo ""
echo "To stop the server:"
echo "  docker-compose down"
