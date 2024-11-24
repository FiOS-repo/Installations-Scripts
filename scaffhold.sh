#Configuration
PACKAGE_MANAGER="apt"
ROOT=true
DEPENDENCIES=("curl", "wget", "zip", "unzip", "tar")
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
    if [ $FORCE = "--force" ];
    then
        echo "Running Script without Yes or No prompts"
        return 1
    else
        read -p "Do you want to proceed? (yes/no) " yn

        case $yn in 
	        yes ) return 1;;
	        no ) return 0;
		        exit;;
	        * ) echo invalid response;

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

    echo "$FORCE"


}

main