#! /bin/bash

# Install packages
sudo apt update
sudo apt install openjdk-21-jdk -y

# Create minecraft user
sudo useradd -r -m -d /home/minecraft minecraft

# Setup Minecraft user and install server edition
sudo -u minecraft bash << 'MINECRAFT_SETUP'
cd /home/minecraft
mkdir -p minecraft_server
cd minecraft_server
wget https://fill-data.papermc.io/v1/objects/a61a0585e203688f606ca3a649760b8ba71efca01a4af7687db5e41408ee27aa/paper-1.21.10-117.jar
# Accept EULA first
echo "eula=true" > eula.txt
MINECRAFT_SETUP

# Create systemd service
sudo cat > /etc/systemd/system/minecraft.service << 'SERVICE'
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=minecraft
WorkingDirectory=/home/minecraft/minecraft_server
ExecStart=/usr/bin/java -Xmx8G -Xms4G -jar paper-1.21.10-117.jar nogui
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable minecraft
sudo systemctl start minecraft

# Clear default Oracle iptables rules (VCN handles security)
sudo iptables -F
sudo iptables -X
