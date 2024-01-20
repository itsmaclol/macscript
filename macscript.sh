#!/usr/bin/env bash
os=$(uname)
arch=$(uname -m)
local_dir="/usr/local/bin"
RED='\033[0;31m'
YELLOW='\033[0;33m'
DARK_GRAY='\033[90m'
LIGHT_CYAN='\033[0;96m'
NO_COLOR='\033[0m'
github_version_url="https://raw.githubusercontent.com/itsmaclol/macscript/main/version.txt"
local_version_file="./version.txt"


error() {
    echo -e " - [${DARK_GRAY}$(date +'%m/%d/%y %H:%M:%S')${NO_COLOR}] ${RED}<Error>${NO_COLOR}: ${RED}$1${NO_COLOR}"
}

info() {
    echo -e " - [${DARK_GRAY}$(date +'%m/%d/%y %H:%M:%S')${NO_COLOR}] ${LIGHT_CYAN}<Info>${NO_COLOR}: ${LIGHT_CYAN}$1${NO_COLOR}"
}

warning() {
    echo -e " - [${DARK_GRAY}$(date +'%m/%d/%y %H:%M:%S')${NO_COLOR}] ${YELLOW}<Warning>${NO_COLOR}: ${YELLOW}$1${NO_COLOR}"
}

if [ "$(id -u)" -ne 0 ]; then error "This script will not run without root or sudo." >&2; exit 1; fi
get_package_manager() {
    if command -v apt-get >/dev/null 2>&1; then
        PACKAGE_MANAGER="apt-get"
    elif command -v yum >/dev/null 2>&1; then
        PACKAGE_MANAGER="yum"
    elif command -v dnf >/dev/null 2>&1; then
        PACKAGE_MANAGER="dnf"
    elif command -v pacman >/dev/null 2>&1; then
        PACKAGE_MANAGER="pacman"
    elif command -v apk >/dev/null 2>&1; then
        PACKAGE_MANAGER="apk"
    elif command -v zypper >/dev/null 2>&1; then
        PACKAGE_MANAGER="zypper"
    else
        PACKAGE_MANAGER="Unknown"
    fi
}

case $os in
    Darwin )
        macos_version=$(sw_vers -productVersion)
        macos_version_major=${macos_version%%.*}
        if [ "$(uname -r | cut -d. -f1)" -gt "15" ]; then
            os_name="macOS"
        elif [ "$(uname -m | head -c2)" = "iP" ]; then
            error "This script is not meant to be used on an iDevice. Please use a PC to use this script."
            exit 1
        else
            os_name="Mac OS X"
        fi
    ;;
    Linux)
        if grep -qi Microsoft /proc/version > /dev/null 2>&1; then
            error "You are running WSL, This script does not support WSL."
               exit 1
        fi
        os_name="Linux"
        get_package_manager
    ;;
esac

dependencies() {
    dependencies=("jq" "curl" "unzip" "git")
    missing_dependencies=()

    for dep in "${dependencies[@]}"; do
            if ! command -v "$dep" > /dev/null; then
                missing_dependencies+=("$dep")
            fi
    done

    if [[ ${#missing_dependencies[@]} -gt 0 ]]; then
        info "Dependencies are missing, would you like to install them?"
        read -r -p "y/n: " install_deps
        case $install_deps in
            y|Y|Yes|YES|yes )
                if [[ "$os" == "Darwin" && -x "$(command -v brew)" ]]; then
                    # Install the missing dependencies using brew
                    sudo -u "$SUDO_USER" brew install "${missing_dependencies[@]}"
                    info "Dependencies installed, please rerun this script."
                    exit 1
                elif [[ "$os" == "Linux" ]]; then
                    case $PACKAGE_MANAGER in
                        "pacman" )
                            # Install dependencies using pacman
                            sudo pacman -Syu "${missing_dependencies[@]}" --noconfirm
                        ;;
                        "apt-get" )
                            # apt
                            sudo apt-get update
                            sudo apt-get install "${missing_dependencies[@]}" -y
                        ;;
                        "yum"|"dnf" )
                            # yum/dnf, same thing tbh
                            sudo dnf update
                            sudo dnf install "${missing_dependencies[@]}" -y
                        ;;
                        "apk" )
                            # apk for alpine
                            sudo apk update
                            sudo apk add "${missing_dependencies[@]}"
                        ;;
                        "zypper" )
                            # and zypper for openSUSE
                            sudo zypper refresh
                            sudo zypper --non-interactive install "${missing_dependencies[@]}"
                        ;;
                    esac
                    info "Dependencies installed, please rerun this script."
                    exit 1
                else
                    error "Unsupported operating system. You need to install ${missing_dependencies[*]} manually."
                    exit 1
                fi
            ;;
            * )
                error "${missing_dependencies[*]} is/are needed for the script to work as intended."
                exit 1
            ;;
        esac
    fi
    case $os in
    Darwin )
        output=$(sudo -u "$SUDO_USER" brew list -1 | grep "libusbmuxd") 
        if [ -z "$output" ]; then
            sudo -u "$SUDO_USER" brew install libusbmuxd
        fi
    ;;
    Linux )
        output=$(dpkg -l | grep libusbmuxd-tools)
        if [ -z "$output" ]; then
            case $PACKAGE_MANAGER in
                "pacman" )
                    # Install dependencies using pacman
                    sudo pacman -Syu libusbmuxd-tools --noconfirm
                ;;
                "apt-get" )
                    # apt
                    sudo apt-get update
                    sudo apt-get install libusbmuxd-tools -y
                ;;
                "yum"|"dnf" )
                    # yum/dnf, same thing tbh
                    sudo dnf update
                    sudo dnf install libusbmuxd-tools -y
                ;;
                "apk" )
                    # apk for alpine
                    sudo apk update
                    sudo apk add libusbmuxd-tools
                ;;
                "zypper" )
                    # and zypper for openSUSE
                    sudo zypper refresh
                    sudo zypper --non-interactive install libusbmuxd-tools
                ;;
            esac
        fi
    ;;
esac
}

internet_check() {
    ping -c 1 -W 1 google.com > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "" > /dev/null
    else
        error "You do not seem to have an internet connection, please connect to the internet and try again, or if you are completely sure that you have internet, use the --ignore-internet-check flag."
        exit 1
    fi
}



local_version=$(cat $local_version_file)
github_version=$(curl -s $github_version_url)

if [[ $github_version > $local_version ]]; then
    version() {
        echo "Local version: $local_version"
        echo "GitHub version: $github_version"
        read -r -p "A new version is available. Do you want to update? (y/n): " version_choice
    }
    version

    case $version_choice in
        y|Y|YES|Yes|yes )
            info "Updating..."
            git pull
        ;;
        n|N|NO|No|no )
            echo "" > /dev/null
        ;;
        * )
            error "Invalid Choice."
            clear
            version
        ;;
    esac
          
else
    echo "" > /dev/null
fi

help_menu() {
        cat << EOF
Usage: $0 [Options]
macscript

Options:
    --help                       Prints this help
    --ignore-internet-check      Ignores the internet check at the beginning of the script. Use this if you are 100% sure that you have internet.
    --ignore-dependencies        Ignores the dependency check at the beginning of the script. Use this if you are 100% sure that you have the dependencies installed.
    --ignore-all-checks Ignores both the internet and dependency check at the beginning of the script. Use this if you are 100% sure that you have the dependencies installed and have internet.
    --ignore-recovery-download   Ignores the macOS recovery download menu, in case you are just trying to make an efi without the macOS installer.

EOF
exit 1
}

case $1 in
    --remove-procursus )
        info "Uninstalling procursus bootstrap..."
        sudo rm -rf /opt/procursus
        info "Done!"
        exit 1
        ;;
    "" )
        dependencies
        internet_check
    ;;
    "--ignore-internet-check" )
        dependencies
    ;;
    "--ignore-dependencies-check" )
        internet_check
    ;;
    "--ignore-all-checks" )
        echo "" > /dev/null
    ;;
    "--help" | "-h" | "--h" )
        help_menu
    ;;
    * )
        error "Unknown arg $1"
        ;;
esac

arch_url_check() {
    case $os in
        Linux )
            case $arch in
                x86_64 )
                    procursus_bootstrap_url="https://apt.procurs.us/bootstraps/big_sur/bootstrap-darwin-amd64.tar.zst"
                    checkra1n_url="https://assets.checkra.in/downloads/linux/cli/x86_64/dac9968939ea6e6bfbdedeb41d7e2579c4711dc2c5083f91dced66ca397dc51d/checkra1n"
                    ;;
                arm )
                    checkra1n_url="https://assets.checkra.in/downloads/linux/cli/arm/ff05dfb32834c03b88346509aec5ca9916db98de3019adf4201a2a6efe31e9f5/checkra1n"
                    ;;
                arm64 )
                    procursus_bootstrap_url="https://apt.procurs.us/bootstraps/big_sur/bootstrap-darwin-arm64.tar.zst"
                    checkra1n_url="https://assets.checkra.in/downloads/linux/cli/arm64/43019a573ab1c866fe88edb1f2dd5bb38b0caf135533ee0d6e3ed720256b89d0/checkra1n"
                    ;;
                i486 )
                    checkra1n_url="https://assets.checkra.in/downloads/linux/cli/i486/77779d897bf06021824de50f08497a76878c6d9e35db7a9c82545506ceae217e/checkra1n"
            esac
            palera1n_recovery_url=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq --arg uname "$(uname -m)" -r '.[0].assets[] | select(.name == "palera1n-linux-\($uname)") | .browser_download_url')
        ;;
        Darwin )
            palera1n_recovery_url=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq -r '.[0].assets[] | select(.name == "palera1n-macos-universal") | .browser_download_url')
        ;;
    esac
}
arch_url_check


checkra1n() {
    case $os in
        Linux )
            info "Detected $os_name on $arch"
            info "Downloading checkra1n for $os_name on $arch"
            curl -sL "$checkra1n_url" -o "$local_dir/checkra1n"
            info "Checkra1n is successfully downloaded, Running..."
            sudo chmod +x "$local_dir"/checkra1n
            warning "In this next screen, you have to enable Untested iOS versions if you're on iOS 14.5 and newer. If not, you can safely ignore this."
            sleep 3
            "$local_dir"/checkra1n
            rm -rf "$local_dir"/checkra1n
            ;;

        Darwin )
            info "Detected $os_name on $arch"
            info "Downloading checkra1n for $os_name on $arch"
            sudo curl -s -L https://assets.checkra.in/downloads/macos/754bb6ec4747b2e700f01307315da8c9c32c8b5816d0fe1e91d1bdfc298fe07b/checkra1n%20beta%200.12.4.dmg -o /usr/local/bin/checkra1n.dmg
            info "Checkra1n is successfully downloaded, Running..."
            sudo hdiutil attach /usr/local/bin/checkra1n.dmg
            warning "In this next screen, you have to enable Untested iOS versions if you're on iOS 14.5 and newer. If not, you can safely ignore this."
            sleep 3
            case $macos_version_major in
                11|12 )
                    sudo /Volumes/checkra1n\ beta\ 0.12.4\ 1/checkra1n.app/Contents/MacOS/checkra1n -V -t 
                    ;;
                * )
                    sudo /Volumes/checkra1n\ beta\ 0.12.4/checkra1n.app/Contents/MacOS/checkra1n -V -t 
                    ;;
            esac
            case $macos_version_major in
                11|12 )
                    sudo hdiutil detach /Volumes/checkra1n\ beta\ 0.12.4\ 1/ 
                    ;;
                * )
                    sudo hdiutil detach /Volumes/checkra1n\ beta\ 0.12.4\
                    ;;
            esac
            rm -rf /usr/local/bin/checkra1n.dmg
    esac
}

odysseyra1n() {
    warning "For odysseyra1n to work, you have to be jailbroken via checkra1n, and to not have opened the checkra1n app after jailbreak, if you have done so, restore rootFS and try again."
    warning "Exit this script now via Ctrl + C if you need to jailbreak with checkra1n, if you have done so and followed the instructions above, you can ignore this message"
    sleep 10
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/coolstar/Odyssey-bootstrap/master/procursus-deploy-linux-macos.sh)"
}

sshrd() {
    info "Detected $os_name on $arch"
    git clone https://github.com/verygenericname/SSHRD_Script --recursive && cd SSHRD_Script
    sudo chmod +x ./sshrd.sh
    info "The device will now be placed in recovery mode, and the palera1n DFU Helper will be launched to put the device in DFU mode."
    curl -L "$palera1n_recovery_url" -o ~/Documents/palera1n-dfu
    chmod +x ~/Documents/palera1n-dfu
    ~/Documents/palera1n-dfu -D
    case $os in
        Linux )
            warning "You will not be able to make a ramdisk for 16.1+, please use something lower instead, like 16.0"
        ;;
    esac
    read -r -p "What iOS version is the device currently running?" ios_version_sshrd
    ./sshrd.sh "$ios_version_sshrd"
    ./sshrd.sh boot
    sleep 10
    ./sshrd.sh ssh
    cd ..
    rm -rf SSHRD_Script ~/Documents/palera1n-dfu
}

apt-procursus() {
    info "Bootstrapping procursus and installing apt..."
    case $os in
        Darwin )
            info "Detected $os_name on $arch"
            cd "$HOME"
            # Download the bootstrap
            curl -Ls "$procursus_bootstrap_url" -o bootstrap.tar.zst
            curl -LsO https://cameronkatri.com/zstd
            chmod +x zstd
            ./zstd -d bootstrap.tar.zst > /dev/null 2>&1
            sudo tar -xpkf bootstrap.tar -C / > /dev/null 2>&1
            sudo mv zstd /opt/procursus/bin/zstd
            printf 'export PATH="/opt/procursus/bin:/opt/procursus/sbin:/opt/procursus/games:$PATH"\nexport CPATH="$CPATH:/opt/procursus/include"\nexport LIBRARY_PATH="$LIBRARY_PATH:/opt/procursus/lib"\n' | sudo tee -a /etc/zshenv /etc/profile 
            export PATH="/opt/procursus/bin:/opt/procursus/sbin:/opt/procursus/games:$PATH"
            export CPATH="$CPATH:/opt/procursus/include"
            export LIBRARY_PATH="$LIBRARY_PATH:/opt/procursus/lib"
            echo >> ~/.zprofile #this fix for apt on macos was taken from azaz, thank you!
            echo PATH="/opt/procursus/bin:/opt/procursus/sbin:/opt/procursus/games:$PATH" >> ~/.zprofile
            echo CPATH="$CPATH:/opt/procursus/include" >> ~/.zprofile
            echo PATH="/opt/procursus/bin:/opt/procursus/sbin:/opt/procursus/games:$PATH" >> ~/.zprofile
            echo CPATH="$CPATH:/opt/procursus/include" >> ~/.zprofile
            echo LIBRARY_PATH="$LIBRARY_PATH:/opt/procursus/lib" >> ~/.zprofile
            echo export PATH >> ~/.zprofile
            echo export CPATH >> ~/.zprofile
            echo export LIBRARY_PATH >> ~/.zprofile
            source ~/.zprofile
            #update and install sileo
            sudo apt update
            sudo apt full-upgrade -y --allow-downgrades
            sudo apt install sileo -y
            rm bootstrap.tar.zst bootstrap.tar
            info "Installation Complete! Be sure to restart your terminal!"
        ;;
        * )
            error "Not supported."
            exit 1
        ;;
    esac
}

palera1n() {
    case $os in
        Linux )
            latest_build=$(curl -s "https://api.github.com/repos/palera1n/palera1n/tags" | jq -r '.[].name' | grep -E "v[0-9]+\.[0-9]+\.[0-9]+-beta\.[0-9]+(\.[0-9]+)*$" | sort -V | tail -n 1) 
            REPO_URL="https://api.github.com/repos/palera1n/palera1n/releases"
            BIN_URL=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq --arg uname "$(uname -m)" -r '.[0].assets[] | select(.name == "palera1n-linux-\($uname)") | .browser_download_url')
            LOCK_FILE="$HOME/macscript_palera1n.lock"
            palera1n_get() {
                info "Detected $os_name on $arch"
                info "Downloading palera1n version ${latest_build} for $os_name on $arch"
                sudo curl -L "$BIN_URL" -o /usr/bin/palera1n
                sudo chmod +x /usr/bin/palera1n
            }
            # Grab the release from Github
            fetch_latest_version() {
                latest_version=$(curl -s $REPO_URL | grep -o '"tag_name": ".*"' | cut -d'"' -f4)
                info "$latest_version"
            }

            #Put the release name in the lock file
            update_lock_file() {
                latest_version=$1
                echo "$latest_version" > "$LOCK_FILE"
                info "Lock file updated with version $latest_version"
            }

            #Read the release name from the lock file
            current_version=$(cat "$LOCK_FILE" 2>/dev/null)

            #Get the release file
            latest_version=$(fetch_latest_version)


            if [[ -z "$current_version" ]]; then
                update_lock_file "$latest_version"
                palera1n_get
            elif [[ "$current_version" != "$latest_version" ]]; then
                info "New palera1n version avaliable, Downloading..."
                update_lock_file "$latest_version"
                palera1n_get
            else
                info "palera1n is up to date."
            fi
            palera1n_main_menu
        ;;
        Darwin )
            latest_build=$(curl -s "https://api.github.com/repos/palera1n/palera1n/tags" | jq -r '.[].name' | grep -E "v[0-9]+\.[0-9]+\.[0-9]+-beta\.[0-9]+(\.[0-9]+)*$" | sort -V | tail -n 1) 
            REPO_URL="https://api.github.com/repos/palera1n/palera1n/releases"
            LOCK_FILE="$HOME/macscript_palera1n.lock"
            BIN_URL=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq -r '.[0].assets[] | select(.name == "palera1n-macos-universal") | .browser_download_url')
            palera1n_get() {
                info "Downloading palera1n version ${latest_build} for $os_name on $arch"
                sudo curl -L -s "$BIN_URL" -o /usr/local/bin/palera1n
                sudo chmod +x /usr/local/bin/palera1n
            }

            # Grab the release from github
            fetch_latest_version() {
                latest_version=$(curl -s $REPO_URL | grep -o '"tag_name": ".*"' | cut -d'"' -f4)
                echo "$latest_version"
            }

            # Update lock file with version
            update_lock_file() {
                latest_version=$1
                echo "$latest_version" > "$LOCK_FILE"
                info "Lock file updated with version $latest_version"
            }

            # Read the current version from the lock file
            current_version=$(cat "$LOCK_FILE" 2>/dev/null)

            latest_version=$(fetch_latest_version)

            # Compare versions and update if needed.
            if [[ -z "$current_version" ]]; then
                update_lock_file "$latest_version"
                palera1n_get
            elif [[ "$current_version" != "$latest_version" ]]; then
                info "New palera1n update available!, downloading..."
                update_lock_file "$latest_version"
                palera1n_get
            else
                info "palera1n is up to date."
            fi
            palera1n_main_menu
        ;;
    esac
}

palera1n_check() {
    case $os in
        Darwin )
            "$local_dir"/palera1n "$@"
        ;;
        Linux ) 
            /usr/bin/palera1n "$@"
        ;;
    esac
}

submenu_rootful() {
    echo "┌───┬────────────────────────────────┐"
    printf "│ %-2s│ %-30s │\n" "1" "Setup FakeFS"
    printf "│ %-2s│ %-30s │\n" "2" "Setup BindFS"
    printf "| %-2s| %-30s |\n" "3" "Clean FakeFS"
    printf "│ %-2s│ %-30s │\n" "4" "Boot"
    printf "│ %-2s│ %-30s │\n" "5" "Enter Recovery Mode"
    printf "│ %-2s│ %-30s │\n" "6" "Exit Recovery Mode"
    printf "│ %-2s│ %-30s │\n" "7" "Safe Mode"
    printf "│ %-2s│ %-30s │\n" "8" "Restore RootFS"
    printf "│ %-2s│ %-30s │\n" "9" "DFU Helper"
    printf "│ %-2s│ %-30s │\n" "10" "Back"
    printf "│ %-2s│ %-30s │\n" "11" "Exit"
    echo "└───┴────────────────────────────────┘"
    read -r -p "Enter the number of the option you want to select: " selection
    case $selection in
        1 )
            palera1n_check -c -f -V
        ;;
        2 )
            palera1n_check -f -V -B
        ;;
        3 )
            palera1n_check -f -V -C
        ;;
        4 )
            palera1n_check -f -V
        ;;
        5 )
            palera1n_check -E
        ;;
        6 )
            palera1n_check -n
        ;;
        7 )
            palera1n_check -s -V -f
        ;;
        8 )
            palera1n_check --force-revert -f -V
        ;;
        9 )
            palera1n_check -D -f -V
        ;;
        10 )
            palera1n_main_menu
        ;;
        11 )
            exit 1
        ;;
        * )
            error "Invalid Selection $selection"
            submenu_rootful
        ;;
    esac
}

submenu_rootless() {
    echo "┌───┬────────────────────────────────┐"
    printf "│ %-2s│ %-30s │\n" "1" "Boot"
    printf "│ %-2s│ %-30s │\n" "2" "Enter Recovery Mode"
    printf "│ %-2s│ %-30s │\n" "3" "Exit Recovery Mode"
    printf "│ %-2s│ %-30s │\n" "4" "DFU Helper"
    printf "│ %-2s│ %-30s │\n" "5" "Restore RootFS"
    printf "│ %-2s│ %-30s │\n" "6" "Back"
    printf "│ %-2s│ %-30s │\n" "7" "Exit"
    echo "└───┴────────────────────────────────┘"
    read -r -p "Enter the number of the option you want to select: " selection
    case $selection in
        1)
            palera1n_check -l -V
        ;;
        2)
            palera1n_check -E
        ;;
        3)
            palera1n_check -n
        ;;
        4)
            palera1n_check -D -l -V
        ;;
        5)
            palera1n_check --force-revert -V
        ;;
        6)
            palera1n_main_menu
            ;;
        7)
            exit 1
            ;;
        *)
            error "Invalid selection $selection"
            ;;
    esac
}

palera1n_main_menu() {
    echo "Welcome to the palera1n submenu!"
    echo "┌───┬────────────────────────────────┐"
    printf "│ %-2s│ %-30s │\n" "1" "Rootful"
    printf "│ %-2s│ %-30s │\n" "2" "Rootless (Recommended)"
    printf "│ %-2s│ %-30s │\n" "3" "Back"
    printf "│ %-2s│ %-30s │\n" "4" "Exit"
    echo "└───┴────────────────────────────────┘"
    read -r -p "Enter the number of what you want to do: " selection
    case $selection in
        1)
            submenu_rootful
            ;;
        2)
            submenu_rootless
            ;;
        3)
            main_menu
            ;;
        4)
            exit
            ;;
        *)
            error "Invalid selection $selection"
            palera1n_main_menu
            ;;
    esac
}


main_menu() {
    echo "Welcome to macscript!"
    echo "┌───┬────────────────────────────────┐"
    printf "│ %-2s│ %-30s │\n" "1" "Install checkra1n"
    printf "│ %-2s│ %-30s │\n" "2" "Run the odysseyra1n Script"
    printf "│ %-2s│ %-30s │\n" "3" "Install palera1n"
    case $os in
        Darwin )
            case $macos_version_major in
                11|12|13|14 )
                    printf "│ %-2s│ %-30s │\n" "4" "Install Procursus (macOS only)"
                    printf "│ %-2s│ %-30s │\n" "5" "SSHRD Script"
                    printf "│ %-2s│ %-30s │\n" "6" "Exit"
                ;;
                * )
                    printf "│ %-2s│ %-30s │\n" "4" "SSHRD Script"
                    printf "│ %-2s│ %-30s │\n" "5" "Exit"
                ;;
            esac
        ;;
        Linux )
            printf "│ %-2s│ %-30s │\n" "4" "SSHRD Script"
            printf "│ %-2s│ %-30s │\n" "5" "Exit"
        ;;
    esac
    echo "└───┴────────────────────────────────┘"

    read -r -p "Enter the number of what you want to do: " selection

    case $selection in
        1)
            checkra1n
            ;;
        2)
            odysseyra1n
            ;;
        3)
            palera1n
            ;;
        4)
            case $os in
                Darwin )
                    case $macos_version_major in
                        11|12|13|14 )
                            apt-procursus
                        ;;
                    * )
                        error "Not supported."
                        exit 1
                    esac
                ;;
                Linux )
                    error "Not Supported."
                    exit 1
                ;;
            esac
        ;;
        5)
            sshrd
            ;;
        6)
            echo "Exiting..."
            exit
            ;;
        *)
            echo "Invalid selection"
            ;;
    esac
}
main_menu
