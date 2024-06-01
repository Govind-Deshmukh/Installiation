#!/bin/bash

set -e

print_section() {
    echo ""
    echo "============================================================"
    echo "$1"
    echo "============================================================"
    echo ""
}

print_section "Build Essential Installation"

sudo apt-get update
sudo apt-get install -y build-essential

print_section "Build Essential Installation Completed and now testing Build Essential Installation"

gcc --version
make --version
g++ --version

print_section "Build Essential Installation Completed"
