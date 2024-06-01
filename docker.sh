#!/bin/bash

set -e

print_section() {
    echo ""
    echo "============================================================"
    echo "$1"
    echo "============================================================"
    echo ""
}

print_section "Docker Installation"

print_section "Adding Docker's official GPG key"

# Update package index and install required packages
sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg

# Create the keyrings directory and add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

print_section "Adding Docker's official repository to Apt sources"

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index after adding Docker's repository
sudo apt-get update

print_section "Starting Docker Installation"

# Install Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

print_section "Adding user to docker group"

# Add current user to the docker group
sudo usermod -aG docker $USER

echo "Please log out and log back in to apply the group changes."

print_section "Docker Installation Completed and now testing Docker Installation"

docker --version
