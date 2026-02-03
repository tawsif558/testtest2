#!/bin/bash

echo "🛠️ Setting up Valheim server environment..."

# Install required dependencies
echo "📦 Installing system dependencies..."
sudo apt update
sudo apt install -y wget curl gpg apt-transport-https ca-certificates

# Install PlayIt.gg using their official method
echo "📥 Installing PlayIt.gg..."

# Method 1: Direct download (most reliable)
if ! command -v playit &> /dev/null; then
    echo "Downloading PlayIt binary..."
    mkdir -p ~/playit
    cd ~/playit
    
    # Download the latest binary
    wget -q https://playit.gg/downloads/playit-linux-64 -O playit
    chmod +x playit
    sudo mv playit /usr/local/bin/playit
    
    # Or use the installer script
    # curl -SsL https://playit.gg/install.sh | bash
    
    echo "✅ PlayIt installed at: $(which playit)"
fi

# Install Docker Compose
echo "📦 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

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
      - PUBLIC=0
    volumes:
      - valheim-data:/config
      - valheim-saves:/opt/valheim

volumes:
  valheim-data:
  valheim-saves:
EOF

# Create auto-start script
cat > /usr/local/bin/start-valheim << 'EOF'
#!/bin/bash
cd /workspaces/valheim
docker-compose up -d
echo "Valheim server started!"
EOF

chmod +x /usr/local/bin/start-valheim

echo "✅ Environment setup complete!"
echo "Server will auto-start when Codespace opens."
