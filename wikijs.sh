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
    #Install
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
