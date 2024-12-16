#!/bin/bash

# Colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

function display_menu() {
    local menu_title="$1"
    local selected="$2"
    shift 2
    local options=("$@")

    clear
    echo -e "${BLUE}${menu_title}${RESET}"
    for i in "${!options[@]}"; do
        if [[ $i -eq $selected ]]; then
            if [[ "${options[i]}" == "Exit" ]]; then
                echo -e "${RED}> ${options[i]}${RESET}"
            else
                echo -e "${GREEN}> ${options[i]}${RESET}"
            fi
        else
            echo "  ${options[i]}"
        fi
    done
}

function navigate_menu() {
    local menu_title="$1"
    shift
    local options=("$@")
    local selected=0

    while true; do
        display_menu "$menu_title" "$selected" "${options[@]}"
        read -s -n3 key

        case "$key" in
            $'\e[A')  # Up arrow
                ((selected--))
                if [[ $selected -lt 0 ]]; then
                    selected=$((${#options[@]} - 1))
                fi
                ;;
            $'\e[B')  # Down arrow
                ((selected++))
                if [[ $selected -ge ${#options[@]} ]]; then
                    selected=0
                fi
                ;;
            $'\e')  # Escape key
                return 255
                ;;
            '')  # Enter key
                return $selected
                ;;
        esac
    done
}

function file_operations() {
    local options=("Create a file" "Delete a file" "List files in current directory" "Create Directory" "Delete Directory" "Back")

    while true; do
        navigate_menu "File Operations" "${options[@]}"
        choice=$?

        if [[ $choice -eq 255 ]]; then
            break
        fi

        case $choice in
            0)
                read -p "Enter the filename to create: " filename
                if touch "$filename"; then
                    echo "File '$filename' created."
                else
                    echo "${RED}Failed to create file!${RESET}"
                fi
                read -p "Press any key to continue..." -n1
                ;;
            1)
                read -p "Enter the filename to delete: " filename
                if rm -i "$filename"; then
                    echo "File '$filename' deleted."
                else
                    echo "${RED}Failed to delete file!${RESET}"
                fi
                read -p "Press any key to continue..." -n1
                ;;
            2)
                echo "Files in current directory:"
                ls -l
                read -p "Press any key to continue..." -n1
                ;;
            3)
                read -p "Enter the name for the Directory to create: " dirname
                if mkdir "$dirname"; then
                    echo "Directory '$dirname' created."
                else
                    echo "${RED}Failed to create directory!${RESET}"
                fi
                read -p "Press any key to continue..." -n1
                ;;
            4)
                read -p "Enter the name for the Directory to delete: " dirname
                if rm -i -r "$dirname"; then
                    echo "Directory '$dirname' deleted."
                else
                    echo "${RED}Failed to delete directory!${RESET}"
                fi
                read -p "Press any key to continue..." -n1
                ;;
            5)
                break
                ;;
        esac
    done
}

function system_info() {
    local options=("View Operating System" "View Kernel Version" "View CPU Info" "View Memory Info" "Back")

    while true; do
        navigate_menu "System Information" "${options[@]}"
        choice=$?

        if [[ $choice -eq 255 ]]; then
            break
        fi

        case $choice in
            0)
                echo "Operating System: $(uname -o)"
                ;;
            1)
                echo "Kernel Version: $(uname -r)"
                ;;
            2)
                echo "CPU Info:"
                lscpu | grep 'Model name'
                ;;
            3)
                echo "Memory Info:"
                free -h | grep 'Mem'
                ;;
            4)
                break
                ;;
        esac
        read -p "Press any key to continue..." -n1
    done
}

function network_check() {
    while true; do
        read -p "Enter the hostname or IP address to ping (or 'b' to go back): " host
        if [[ "$host" == "b" ]]; then
            break
        fi
        if ping -c 4 "$host"; then
            echo "Ping successful."
        else
            echo "${RED}Ping failed. Check the hostname or network.${RESET}"
        fi
        read -p "Press any key to continue..." -n1
    done
}

function main_menu() {
    local options=("File Operations" "System Info" "Network Check" "Help" "Exit")

    while true; do
        navigate_menu "Main Menu" "${options[@]}"
        choice=$?

        if [[ $choice -eq 255 ]]; then 
            exit 0
        fi

        case $choice in
            0)
                file_operations
                ;;
            1)
                system_info
                ;;
            2)
                network_check
                ;;
            3)
                display_help
                read -p "Press any key to continue..." -n1
                ;;
            4)
                exit 0
                ;;
        esac
    done
}

function display_help() {
    clear
    echo "Multitool Script Help"
    echo "---------------------"
    echo "Use arrow keys to navigate."
    echo "Press Enter to select an option."
    echo "Press Esc to go back to the previous menu."
}

# Start the main menu
main_menu
