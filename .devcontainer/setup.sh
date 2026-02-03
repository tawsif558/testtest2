#!/bin/bash

echo "🛠️ Setting up Valheim server environment..."

# Install PlayIt.gg
echo "📥 Installing PlayIt.gg..."
curl -SsL https://playit.gg/install.sh | bash

# Install Docker Compose
echo "📦 Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create server directory
mkdir -p /workspaces/valheim

# Create docker-compose.yml for Valheim
cat > /workspaces/valheim/docker-compose.yml << 'EOF'
version: '3.8'

services:
  valheim:
    image: lloesche/valheim-server
    restart: unless-stopped
    ports:
      - "2456-2458:2456-2458/udp"
    environment:
      - SERVER_NAME=Valheim Codespace Server
      - SERVER_PASS=codespace123
      - WORLD_NAME=CodespaceWorld
    volumes:
      - valheim-data:/config
      - valheim-saves:/opt/valheim

volumes:
  valheim-data:
  valheim-saves:
EOF

echo "✅ Environment setup complete!"
echo "Server will auto-start when Codespace opens."
