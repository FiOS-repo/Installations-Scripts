#!/bin/bash

echo "
███████╗██╗███╗   ██╗███╗   ██╗███████╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
██╔════╝██║████╗  ██║████╗  ██║██╔════╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
█████╗  ██║██╔██╗ ██║██╔██╗ ██║███████╗    ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
██╔══╝  ██║██║╚██╗██║██║╚██╗██║╚════██║    ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
██║     ██║██║ ╚████║██║ ╚████║███████║    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
                                                                                               
"

install() {
    if command -v docker &> /dev/null; then
        echo "Docker is already installed. Version: $(docker --version)"

    else
        echo "Docker is not installed."
        echo "Docker is going to be installed"
        curl -fsSL https://get.docker.com -o get-docker.sh
        echo "Running Docker installation script..."
        sudo sh get-docker.sh
        echo "Removing Docker installation script..."
        rm get-docker.sh
        echo "Deploying Wiki.js..."
    fi
    echo "Run PostgreSQL (in Docker)"
    docker network create wiki-net
    docker run -d \
      --name wiki-db \
      --network wiki-net \
      -e POSTGRES_DB=wiki \
      -e POSTGRES_USER=wikijs \
      -e POSTGRES_PASSWORD=wikijsrocks \
      -v wiki-db-data:/var/lib/postgresql/data \
      --restart unless-stopped \
      postgres:15-alpine

    }

    echo "Run Wiki.js"
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
    echo "Editing firewall"
    sudo ufw allow 5230/tcp
    sudo ufw status
    sudo ufw enable
    if [ $? -eq 0 ]; then
        echo "Firewall setup completed successfully."
    else
        echo "Error: Failed to set up Firewall."
    fi

update_system() {
    echo "Updating the system..."
    sudo apt update && sudo apt upgrade -y
    if [ $? -eq 0 ]; then
        echo "System update completed successfully."
    else
        echo "Error: System update failed."
    fi
    install
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" == "ubuntu" ]; then
        echo "The system is Ubuntu."

        # Ask the user if they want to update
        read -p "Do you want to update the system? (y/n): " response
        case $response in
            [Yy]* )
                update_system
                ;;
            [Nn]* )
                echo "System update skipped."
                install
                ;;
            * )
                echo "Invalid response. Please answer y or n."
                ;;
        esac
    else
        echo "This script is intended for Ubuntu systems only."
    fi
else
    echo "Cannot determine the operating system."
fi
