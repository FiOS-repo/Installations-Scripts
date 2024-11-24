#Configuration
PACKAGE_MANAGER="apt"
ROOT=true
DEPENDENCIES=("curl", "wget", "zip", "unzip", "tar")
SCRIPTS='echo Hello World'
UPDATE_PACKAGES=true

echo "
███████╗██╗███╗   ██╗███╗   ██╗███████╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
██╔════╝██║████╗  ██║████╗  ██║██╔════╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
█████╗  ██║██╔██╗ ██║██╔██╗ ██║███████╗    ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
██╔══╝  ██║██║╚██╗██║██║╚██╗██║╚════██║    ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
██║     ██║██║ ╚████║██║ ╚████║███████║    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
"

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
}

main