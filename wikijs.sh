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
}

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
