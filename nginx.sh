#!/bin/bash

set -e

print_section() {
    echo ""
    echo "============================================================"
    echo "$1"
    echo "============================================================"
    echo ""
}


print_section "Nginx Installation"

sudo apt-get update
sudo apt-get install -y nginx

print_section "Starting Nginx"
sudo systemctl start nginx
sudo systemctl enable nginx

print_section "Nginx Installation Completed and now testing Nginx Installation"

nginx -v
curl -I http://localhost

print_section "Nginx Installation Completed"