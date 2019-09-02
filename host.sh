#!/bin/sh

# Configure your nfs.
# Input your client's ip.
echo "Please input your client's ip:"
read client_ip

# Downloading and Installing the Components
sudo apt-get update
sudo apt-get install nfs-kernel-server

# Configuring the NFS Exports on the Host Server
# Attention! It will destroy your origin configurations about /etc/exports!
echo "/home       $client_ip(rw,sync,no_root_squash,no_subtree_check)" | sudo tee  /etc/exports
sudo systemctl restart nfs-kernel-server



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
