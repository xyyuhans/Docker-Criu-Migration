#!/bin/sh

# Configure your nfs.
# Input your host's ip.
echo "Please input your host's ip:"
read host_ip

# Downloading and Installing the Components
sudo apt-get update
sudo apt-get install nfs-common

# Creating the Mount Points on the Client
sudo mkdir -p /nfs/home
# Mounting the Directory on the Client
sudo mount $host_ip:/home /nfs/home

# Checking the Mounted Directory on the Client
df -h



# Configure your docker.
# Run docker without sudo
sudo groupadd docker
sudo usermod -aG docker $USER

# docker checkpoint is an experimental feature, so you should enable docker experimental feature
echo '{
    "experimental": true
}' | sudo tee /etc/docker/daemon.json
systemctl restart docker
systemctl enable docker
