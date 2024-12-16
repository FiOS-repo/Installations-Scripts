#!/bin/bash

# Define log function with blue background
log() {
    echo -e "\e[44m$1\e[0m"
}
log_success() {
    echo -e "\e[42m$1\e[0m"
}

# Initialize the FORCE_BYPASS flag
FORCE_BYPASS=false

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_BYPASS=true
            ;;
        *)
            log "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

echo "
███╗   ██╗███████╗██╗  ██╗████████╗ ██████╗ ██████╗ ██╗     ██████╗ 
████╗  ██║██╔════╝██║  ██║╚══██╔══╝██╔════╝██╔═══██╗██║     ██╔══██╗
██╔██╗ ██║███████╗███████║   ██║   ██║     ██║   ██║██║     ██║  ██║
██║╚██╗██║╚════██║██╔══██║   ██║   ██║     ██║   ██║██║     ██║  ██║
██║ ╚████║███████║██║  ██║   ██║   ╚██████╗╚██████╔╝███████╗██████╔╝
╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═════╝ ╚══════╝╚═════╝ 
"

install_nextcloud() {
    log "Installing Docker..."
    if command -v docker &> /dev/null; then
        log "Docker is already installed. Version: $(docker --version)"
    else
        log "Docker is not installed. Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh
        log "Docker installed successfully."
    fi

    log "Setting up Nextcloud using Docker..."

    docker network create nextcloud-net || log "Network 'nextcloud-net' already exists."
    
    log "Setting up MariaDB..."
    docker run -d \
      --name nextcloud-db \
      --network nextcloud-net \
      -e MYSQL_ROOT_PASSWORD=rootpassword \
      -e MYSQL_DATABASE=nextcloud \
      -e MYSQL_USER=nextcloud \
      -e MYSQL_PASSWORD=nextcloudpassword \
      -v nextcloud-db-data:/var/lib/mysql \
      --restart unless-stopped \
      mariadb:latest

    log "Setting up Nextcloud..."
    docker run -d \
      --name nextcloud \
      --network nextcloud-net \
      -p 8080:80 \
      -v nextcloud-data:/var/www/html \
      -e MYSQL_HOST=nextcloud-db \
      -e MYSQL_DATABASE=nextcloud \
      -e MYSQL_USER=nextcloud \
      -e MYSQL_PASSWORD=nextcloudpassword \
      --restart unless-stopped \
      nextcloud:latest

    log "Configuring firewall..."
    sudo ufw allow 8080/tcp
    sudo ufw reload
    sudo ufw enable
    if [ $? -eq 0 ]; then
        log "Firewall setup completed successfully."
    else
        log "Error: Failed to set up Firewall."
    fi

    log_success "Nextcloud is now successfully installed!"
    log_success "Access it at http://localhost:8080"
}

update_system() {
    log "Updating the system..."
    sudo apt update && sudo apt upgrade -y
    if [ $? -eq 0 ]; then
        log "System update completed successfully."
    else
        log "Error: System update failed."
        exit 1
    fi
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"debian"* || "$FORCE_BYPASS" == true ]]; then
        if [ "$FORCE_BYPASS" == true ]; then
            log "Bypassing system requirement check as --force was used."
        else
            log "The system is Debian-based."
        fi

        read -p "Do you want to update the system before installing Docker and Nextcloud? (y/n): " response
        case $response in
            [Yy]* )
                update_system
                ;;
            [Nn]* )
                log "Skipping system update."
                ;;
            * )
                log "Invalid response. Please answer y or n."
                exit 1
                ;;
        esac

        install_nextcloud
    else
        log "This script is intended for Debian-based systems only. Use --force to bypass this check."
        exit 1
    fi
else
    if [ "$FORCE_BYPASS" == true ]; then
        log "Bypassing system requirement check as --force was used."
        install_nextcloud
    else
        log "Cannot determine the operating system. Use --force to bypass this check."
        exit 1
    fi
fi
