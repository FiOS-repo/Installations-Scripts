#!/bin/bash

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
        echo "Docker is already installed. Version: $(docker --version)"
    else
        echo "Docker is not installed. Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh
        echo "Docker installed successfully."
    fi

    echo "Setting up PostgreSQL (in Docker)..."
    docker network create wiki-net || echo "Network 'wiki-net' already exists."
    docker run -d \
      --name wiki-db \
      --network wiki-net \
      -e POSTGRES_DB=wiki \
      -e POSTGRES_USER=wikijs \
      -e POSTGRES_PASSWORD=wikijsrocks \
      -v wiki-db-data:/var/lib/postgresql/data \
      --restart unless-stopped \
      postgres:15-alpine

    echo "Deploying Wiki.js..."
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

    echo "Configuring firewall..."
    sudo ufw allow 80/tcp
    sudo ufw reload
    sudo ufw enable
    if [ $? -eq 0 ]; then
        echo "Firewall setup completed successfully."
    else
        echo "Error: Failed to set up Firewall."
    fi
}

update_system() {
    echo "Updating the system..."
    sudo apt update && sudo apt upgrade -y
    if [ $? -eq 0 ]; then
        echo "System update completed successfully."
    else
        echo "Error: System update failed."
        exit 1
    fi
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" == "ubuntu" ]; then
        echo "The system is Ubuntu."

        read -p "Do you want to update the system before installing Docker and Wiki.js? (y/n): " response
        case $response in
            [Yy]* )
                update_system
                ;;
            [Nn]* )
                echo "Skipping system update."
                ;;
            * )
                echo "Invalid response. Please answer y or n."
                exit 1
                ;;
        esac

        install_docker_and_wiki
    else
        echo "This script is intended for Ubuntu systems only."
        exit 1
    fi
else
    echo "Cannot determine the operating system. Aborting."
    exit 1
fi
