#Configuration
PACKAGE_MANAGER="apt"
ROOT=true
DEPENDENCIES=("curl" "wget" "zip" "unzip" "tar")
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

yesorno () {
    if [[ "$FORCE" == "--force" ]]; then
        echo "Running script without Yes or No prompts"
        return 1
    else
        read -p "$1 (yes/no) " yn
        case $yn in
            yes) return 1 ;;
            no) return 0 ;;
            *) echo "Invalid response"; return 2 ;;
        esac
    fi
}


main () {
    if [ $ROOT = true ];
    then
        if [ $USER != "root" ];
        then 
            echo "Please run this script as root"
            exit 1
        fi
    fi
    echo "Running script as user: $USER"

    if ! yesorno "Do you want to procced? " ; then
        echo "Installing dependencies"
        for value in "${DEPENDENCIES[@]}"
    do
        echo "Installing: $value";
        sudo apt install -y $value
    done
    fi


}

main