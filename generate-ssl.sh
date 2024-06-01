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
    sudo ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/
    sudo nginx -t
    sudo systemctl restart nginx
    print_section "Nginx Configuration Completed"
}

nginx_version=$(nginx -v 2>&1)
if [ $? -eq 0 ]; then
    print_section "Nginx is installed: $nginx_version"
else
    print_section "Nginx is not installed . . . Installing Nginx"
    sudo apt install -y nginx
    exit 1
fi

certbot_installed=$(certbot --version 2>&1)

if [ $? -eq 0 ]; then
    print_section "Certbot is installed or not? $certbot_installed"
else
    print_section "Certbot is not installed . . . Installing Certbot"
    sudo snap install certbot --classic
    exit 1
fi

echo ""
echo "============================================================"
print_section "is nginx config already configured ?"
read nginx_configured
if [ "$nginx_configured" == "y" ]; then
    read -p "Enter your domain name: " domain
    read -p "Enter the port number for backend server: " backend_port
    create_nginx_config $domain $backend_port
    sudo certbot --nginx -d $domain    
    print_section "Generate SSL Certificates"
    exit 1
else
    print_section "Nginx is not configured"
    read -p "Enter your domain name: " domain
    read -p "Enter the port number for backend server: " backend_port
    create_nginx_config $domain $backend_port
    sudo certbot --nginx -d $domain
    print_section "Generate SSL Certificates"
    exit 1
fi