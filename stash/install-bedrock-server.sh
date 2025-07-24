#!/bin/bash

#Set some variables
port='19132'
portv6='19133'
server='bedrock-server'
user='minecraft_user'
installation_dir="/opt/$server"

# Check if the script is being run with sudo privileges.
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with sudo. Exiting."
    exit 1

# Check if is Ubuntu or Debian Linux
elif [ ! -f /etc/os-release ] || ( . /etc/os-release && [ "$ID" != "ubuntu" ] && [ "$ID" != "debian" ]); then
    echo "This is unsupported OS. Minecraft Bedrock Edition is only suported on Ubuntu or Debian"
    exit 1

# Check if already installed
elif [ -d "$installation_dir" ]; then
    echo "Directory $installation_dir already exists. Exiting."
    exit 1

# Check if ports are available
elif ss -nlup | grep -q ":$port"; then
    echo "Port $port is being used by another process."
    if ss -nlup | grep -q ":$portv6"; then
        echo "Port $portv6 is being used by another process."
    fi
    exit 1
elif ss -nlup | grep -q ":$portv6"; then
    echo "Port $portv6 is being used by another process."
    exit 1
fi

# Update package lists and install required dependencies
# Replace supervisor with Docker and Docker Compose
apt-get update -y
apt-get install -y wget zip unzip curl docker.io docker-compose-plugin

# Enable and start Docker service
systemctl enable docker
systemctl start docker

# Download and install latest Minecraft Bedrock Edition Server.
link=$(curl -s https://net-secondary.web.minecraft-services.net/api/v1.0/download/links | grep -oP '"downloadType":"serverBedrockLinux"[^}]*"downloadUrl":"\K[^"]+')

zip_file=$(basename "$link")

wget --header="Referer: https://www.minecraft.net/en-us/download/server/bedrock" --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36" -P /tmp "$link"
if [ $? -ne 0 ]; then
    echo "Failed to download $zip_file. Exiting."
    exit 1
fi

# Create user with UID 1000 to match Docker Compose configuration
useradd -M -u 1000 $user 2>/dev/null || usermod -u 1000 $user
usermod -L $user

unzip -o /tmp/"$zip_file" -d $installation_dir

# Update server name and ports in server.properties
sed -i "s/server-name=.*/server-name=$server/" "$installation_dir/server.properties"
sed -i "s/server-port=.*/server-port=$port/" "$installation_dir/server.properties"
sed -i "s/server-portv6=.*/server-portv6=$portv6/" "$installation_dir/server.properties"

# Set proper ownership for Docker Compose (UID 1000)
chown -R 1000:1000 $installation_dir

echo "Cleaning up..."
rm /tmp/"$zip_file"

# Start Minecraft Server using Docker Compose instead of Supervisor
echo "Starting Minecraft Server with Docker Compose..."

# Navigate to the directory containing docker-compose.yml
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy docker-compose.yml to installation directory for self-contained setup
echo "Setting up Docker Compose configuration..."
cp "$script_dir/docker-compose.yml" "$installation_dir/"

# Navigate to installation directory to run Docker Compose
cd "$installation_dir"

# Start the server using Docker Compose
docker compose up -d

# Wait for container to start
sleep 5

# Check container status
docker compose ps

# ... existing code ...

# Check if iptables installed
if command -v iptables &>/dev/null; then
    # Check if the rule allowing traffic on specified $port exists
    if sudo iptables -C INPUT -p udp --dport $port -j ACCEPT &>/dev/null; then
        echo "Port $port is open"
    else
    # Allow traffic on specified $port.
        echo "Opening port $port..."
        iptables -I INPUT -p udp -m udp --dport $port -j ACCEPT
        iptables-save > /etc/iptables/rules.v4
    fi
else
    echo "No iptables installed"
fi

sleep 5

# Check if server is running by checking container status and port
if docker compose ps | grep -q "Up" && ss -nlup | grep -q ":$port"; then
    echo
    echo "Installation completed. Your server is running and listening on UDP port $port."
    echo
    echo "Please ensure that UDP port $port is also open in your security list/group."
    echo
    echo "Server management commands:"
    echo "  Start server:     docker compose up -d"
    echo "  Stop server:      docker compose down"
    echo "  View logs:        docker compose logs -f"
    echo "  Server console:   docker compose exec bedrock-server bash"
    echo "  Restart server:   docker compose restart"
else
    echo "Port $port UDP is not listening. Installation may have failed or the server is not running."
    echo "Check logs with: docker compose logs"
fi
