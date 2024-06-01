#!/bin/bash

set -e

print_section() {
    echo ""
    echo "============================================================"
    echo "$1"
    echo "============================================================"
    echo ""
}

create_nginx_config() {
    sudo tee /etc/nginx/sites-available/$1 <<EOF
server {
    listen 80;
    server_name $1;

    location / {
        proxy_pass http://127.0.0.1:$2;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
}

read -p "Do you have nginx installed? (y/n) " nginx

if [ "$nginx" == "y" ]; then
    print_section "Nginx is installed"
else
    print_section "Nginx is not installed"
    exit 1
fi

read -p "Do you have certbot installed? (y/n) " certbot
if [ "$certbot" == "y" ]; then
    print_section "Certbot is installed"
else
    print_section "Certbot is not installed"
    exit 1
fi

read -p "Is nginx already configured? (y/n) " nginx_configured

if [ "$nginx_configured" == "y" ]; then
    print_section "Nginx is already configured"
else
    print_section "Nginx is not configured"
    exit 1
fi

read -p "Enter your domain name: " domain
read -p "Enter the port number for backend server: " backend_port

create_nginx_config $domain $backend_port

sudo certbot certonly --nginx -d $domain

print_section "Generate SSL Certificates"
