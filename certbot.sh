#!/bin/bash

set -e

print_section() {
    echo ""
    echo "============================================================"
    echo "$1"
    echo "============================================================"
    echo ""
}

print_section "Certbot Installation"

sudo apt-get update

print_section "Installing Snapd"

sudo apt install -y snapd

print_section "Installing Certbot"

sudo snap install certbot --classic