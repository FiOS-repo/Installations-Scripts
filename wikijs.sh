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
███████╗██╗███╗   ██╗███╗   ██╗███████╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
██╔════╝██║████╗  ██║████╗  ██║██╔════╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
█████╗  ██║██╔██╗ ██║██╔██╗ ██║███████╗    ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
██╔══╝  ██║██║╚██╗██║██║╚██╗██║╚════██║    ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
██║     ██║██║ ╚████║██║ ╚████║███████║    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
                                                                                               
"


install_docker_and_wiki() {
    if command -v docker &> /dev/null; then
        log "Docker is already installed. Version: $(docker --version)"
    else
        log "Docker is not installed. Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh
        log "Docker installed successfully."
    fi

    log "Setting up PostgreSQL (in Docker)..."
    docker network create wiki-net || log "Network 'wiki-net' already exists."
    docker run -d \
      --name wiki-db \
      --network wiki-net \
      -e POSTGRES_DB=wiki \
      -e POSTGRES_USER=wikijs \
      -e POSTGRES_PASSWORD=wikijsrocks \
      -v wiki-db-data:/var/lib/postgresql/data \
      --restart unless-stopped \
      postgres:15-alpine

    log "Deploying Wiki.js..."
    docker run -d \
        --name wiki \
        --network wiki-net \
        -e DB_TYPE=postgres \
        -e DB_HOST=wiki-db \
        -e DB_PORT=5432 \
        -e DB_USER=wikijs \
        -e DB_PASS=wikijsrocks \
        -e DB_NAME=wiki \
        -p 80:3000 \
        --restart unless-stopped \
        ghcr.io/requarks/wiki:2

    log "Configuring firewall..."
    sudo ufw allow 80/tcp
    sudo ufw reload
    sudo ufw enable
    if [ $? -eq 0 ]; then
        log "Firewall setup completed successfully."
    else
        log "Error: Failed to set up Firewall."
    fi

    log_success "Wiki.js is now sucssesfully installed!"
    log_success "Thanks for using Finn's scripts!"
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

        read -p "Do you want to update the system before installing Docker and Wiki.js? (y/n): " response
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

        install_docker_and_wiki
    else
        log "This script is intended for Debian-based systems only. Use --force to bypass this check."
        exit 1
    fi
else
    if [ "$FORCE_BYPASS" == true ]; then
        log "Bypassing system requirement check as --force was used."
        install_docker_and_wiki
    else
        log "Cannot determine the operating system. Use --force to bypass this check."
        exit 1
    fi
fi