#!/bin/bash

set -e

print_section() {
    echo ""
    echo "============================================================"
    echo "$1"
    echo "============================================================"
    echo ""
}

print_section "Installing JAVA 17 LTS if not installed"

if ! command -v java &> /dev/null; then
    echo "Java 17 LTS is not installed"
    echo "Installing Java 17 LTS"
    sudo apt-get update
    sudo apt-get install -y openjdk-17-jdk
else
    echo "Java 17 LTS is already installed"
fi

java --version

print_section "Jenkins Installation"

read -p "Enter Jenkins domain name: " jenkins_domain

print_section "Installing Jenkins"

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install -y jenkins

print_section "Starting Jenkins"

sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "Jenkins initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

print_section "Jenkins Installation Completed"
