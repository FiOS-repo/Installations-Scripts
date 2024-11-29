#!/bin/bash

# Configuration
PACKAGE_MANAGER="apt"
ROOT=true
DEPENDENCIES=("curl" "wget" "zip" "unzip" "tar")
BUILD_DEPENDENCIES=("lolcat")
SCRIPTS='echo Hello World'
UPDATE_PACKAGES=true
FORCE=$1

echo "
███████╗██╗███╗   ██╗███╗   ██╗███████╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
██╔════╝██║████╗  ██║████╗  ██║██╔════╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
█████╗  ██║██╔██╗ ██║██╔██╗ ██║███████╗    ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
██╔══╝  ██║██║╚██╗██║██║╚██╗██║╚════██║    ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
██║     ██║██║ ╚████║██║ ╚████║███████║    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
"

# Function to handle yes/no prompts
yesorno () {
    if [[ "$FORCE" == "--force" ]]; then
        echo "Running script without Yes or No prompts"
        return 1
    fi

    while true; do
        read -p "$1 (yes/no): " yn
        case $yn in
            yes) return 1 ;;
            no) return 0 ;;
            *) echo "Invalid response. Please type 'yes' or 'no'." ;;
        esac
    done
}

# Main script logic
main () {
    # Check if the script requires root and enforce it
    if [ "$ROOT" = true ]; then
        if [ "$(id -u)" -ne 0 ]; then
            echo "Please run this script as root"
            exit 1
        fi
    fi

    echo "Running script as user: $USER"

    # Update packages if enabled
    if [ "$UPDATE_PACKAGES" = true ]; then
        if yesorno "Do you want to update packages?"; then
            sudo $PACKAGE_MANAGER update
            sudo $PACKAGE_MANAGER upgrade -y
        fi
    fi

    # Confirm continuation
    if yesorno "Do you want to proceed?"; then
        echo "Installing dependencies"
        for value in "${DEPENDENCIES[@]}"; do
            echo "Installing: $value"
            sudo $PACKAGE_MANAGER install -y "$value"
        done
    fi

    echo "Installing build dependencies"
    for value in "${BUILD_DEPENDENCIES[@]}"; do
        echo "Installing: $value"
        sudo $PACKAGE_MANAGER install -y "$value"
    done

    # Execute user-defined scripts
    eval "$SCRIPTS"

    # Uninstall build dependencies
    echo "Uninstalling build dependencies"
    for value in "${BUILD_DEPENDENCIES[@]}"; do
        echo "Uninstalling: $value"
        sudo $PACKAGE_MANAGER remove -y "$value"
    done
}

# Run the main function
main
