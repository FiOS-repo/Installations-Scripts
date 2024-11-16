#!/bin/bash

echo "
███████╗██╗███╗   ██╗███╗   ██╗███████╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
██╔════╝██║████╗  ██║████╗  ██║██╔════╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
█████╗  ██║██╔██╗ ██║██╔██╗ ██║███████╗    ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
██╔══╝  ██║██║╚██╗██║██║╚██╗██║╚════██║    ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
██║     ██║██║ ╚████║██║ ╚████║███████║    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
                                                                                               
"

# Function to install software
install() {
    echo "Downloading Docker installation script..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    if [ $? -eq 0 ]; then
        echo "Running Docker installation script..."
        sudo sh get-docker.sh
        echo "Removing Docker installation script..."
        rm get-docker.sh
        echo "Deploying Memos..."
        docker run -d --name memos -p 5230:5230 -v ~/.memos/:/var/opt/memos neosmemo/memos:stable
        if [ $? -eq 0 ]; then
            echo "Software installation completed successfully."
        else
            echo "Error: Failed to deploy Memos."
        fi
        echo "Setting up Firewall..."
        sudo ufw allow 5230/tcp
        sudo ufw status
        sudo ufw enable
        if [ $? -eq 0 ]; then
        echo "Firewall setup completed successfully."
        else
        echo "Error: Failed to set up Firewall."
        fi
        
    else
        echo "Error: Failed to download Docker installation script."
    fi
    echo "Thanks for using Finn's script!"
}

# Function to update the system
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

# Check if the system is Ubuntu
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
