#!/usr/bin/env bash

# Thank you to palera1n install.sh for a lot of help and a lot of insipration with this script
os=$(uname)
arch_check=$(uname -m)
# Taken entirely from palera1n install.sh
case "$os" in
    Linux)
        os_name="Linux"
    ;;
    Darwin)
        if [ "$(uname -r | cut -d. -f1)" -gt "15" ]; then
            os_name="macOS"
        elif [ "$(uname -m | head -c2)" = "iP" ]; then
            error "This script is not meant to be used on an iDevice. Please use a PC to use this script."
            exit 1
        else
            os_name="Mac OS X"
        fi
        arch_check=$(uname -m)
    ;;
    *)
        error "Unknown or unsupported OS ($os)."
        exit 1
    ;;
esac

# macOS Version
case $os in
    Darwin )
        macos_version=$(sw_vers -productVersion)
        macos_version_major=${macos_version%%.*}
    ;;
esac


# Thanks to palera1n install.sh and to checkra1n for this coloring scheme!
RED='\033[0;31m'
YELLOW='\033[0;33m'
DARK_GRAY='\033[90m'
LIGHT_CYAN='\033[0;96m'
NO_COLOR='\033[0m'

# Logging functions
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

case $1 in
    --remove-procursus )
        info "Uninstalling procursus bootstrap..."
        sudo rm -rf /opt/procursus
        info "Done!"
        exit 1
        ;;
    "" )
        echo "" > /dev/null 2>&1
        ;;
    * )
        error "Unknown command."
        ;;
esac

checkra1n() {
    case $os in
        Linux )
            info "Detected $os_name on $arch_check"
            info "Downloading checkra1n for $os_name on $arch_check"
            case $arch_check in
                x86_64 )
                    curl -s -L https://assets.checkra.in/downloads/linux/cli/x86_64/dac9968939ea6e6bfbdedeb41d7e2579c4711dc2c5083f91dced66ca397dc51d/checkra1n -o /usr/bin/checkra1n
                    ;;
                arm )
                    curl -s -L https://assets.checkra.in/downloads/linux/cli/arm/ff05dfb32834c03b88346509aec5ca9916db98de3019adf4201a2a6efe31e9f5/checkra1n -o /usr/bin/checkra1n
                    ;;
                arm64 )
                    curl -s -L https://assets.checkra.in/downloads/linux/cli/arm64/43019a573ab1c866fe88edb1f2dd5bb38b0caf135533ee0d6e3ed720256b89d0/checkra1n -o /usr/bin/checkra1n
                    ;;
                i486 )
                    curl -s -L https://assets.checkra.in/downloads/linux/cli/i486/77779d897bf06021824de50f08497a76878c6d9e35db7a9c82545506ceae217e/checkra1n -o /usr/bin/checkra1n
            esac
            info "Checkra1n is successfully downloaded, Running..."
            sudo chmod +x /usr/bin/checkra1n
            warning "In this next screen, you have to enable Untested iOS versions if you're on iOS 14.5 and newer. If not, you can safely ignore this."
            sleep 3
            /usr/bin/checkra1n
            rm -rf /usr/bin/checkra1n
            ;;

        Darwin )
            info "Detected $os_name on $arch_check"
            info "Downloading checkra1n for $os_name on $arch_check"
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
    case $os in
        Darwin )
            if ! command -v brew &> /dev/null; then
                warning "Brew not found. Installing..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            else
                echo "" > /dev/null 2>&1
            fi
            sudo -u "$SUDO_USER" brew install libusbmuxd
            warning "For odysseyra1n to work, you have to be jailbroken via checkra1n, and to not have opened the checkra1n app after jailbreak, if you have done so, restore rootFS and try again."
            warning "Exit this script now via Ctrl + C if you need to jailbreak with checkra1n, if you have done so and followed the instructions above, you can ignore this message"
            sleep 10
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/coolstar/Odyssey-bootstrap/master/procursus-deploy-linux-macos.sh)"
        ;;
        Linux )
            if dpkg -s libusbmuxd-tools >/dev/null 2>&1; then
                info "Installing dependencies..." 
            else
                echo "" > /dev/null 2>&1
            fi
            warning "For odysseyra1n to work, you have to be jailbroken via checkra1n, and to not have opened the checkra1n app after jailbreak, if you have done so, restore rootFS and try again."
            warning "Exit this script now via Ctrl + C if you need to jailbreak with checkra1n, if you have done so and followed the instructions above, you can ignore this message"
            sleep 10
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/coolstar/Odyssey-bootstrap/master/procursus-deploy-linux-macos.sh)"
        ;;
    esac
}

sshrd() {
    case $os in
        Darwin )
            info "Detected $os_name on $arch_check"
            git clone https://github.com/verygenericname/SSHRD_Script --recursive && cd SSHRD_Script
            sudo chmod +x ./sshrd.sh
            info "The device will now be placed in recovery mode, and the palera1n DFU Helper will be launched to put the device in DFU mode."
            url=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq -r '.[0].assets[] | select(.name == "palera1n-macos-universal") | .browser_download_url')
            curl -L "$url" -o ~/Documents/palera1n-dfu
            chmod +x ~/Documents/palera1n-dfu
            ~/Documents/palera1n-dfu -D
            read -r -p "What iOS version is the device currently running?" ios_version_sshrd
            ./sshrd.sh "$ios_version_sshrd"
            ./sshrd.sh boot
            sleep 10
            ./sshrd.sh ssh
            cd ..
            rm -rf SSHRD_Script ~/Documents/palera1n-dfu
        ;;
        Linux )
            if git --version >/dev/null 2>&1; then
                echo "" > /dev/null 2>&1 
            else
                info "Installing dependencies..."
                sudo apt install git -y
            fi
            info "Detected $os_name on $arch_check"
            git clone https://github.com/verygenericname/SSHRD_Script --recursive && cd SSHRD_Script
            sudo chmod +x ./sshrd.sh
            info "The device will now be placed in recovery mode, and the palera1n DFU Helper will be launched to put the device in DFU mode."
            url=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq --arg uname "$(uname -m)" -r '.[0].assets[] | select(.name == "palera1n-linux-\($uname)") | .browser_download_url')
            curl -L "$url" -o ~/Documents/palera1n-dfu
            chmod +x ~/Documents/palera1n-dfu
            ~/Documents/palera1n-dfu -D
            warning "You will not be able to make a ramdisk for 16.1+, please use something lower instead, like 16.0"
            read -r -p "What iOS version is the device currently running?" ios_version_sshrd
            ./sshrd.sh "$ios_version_sshrd"
            ./sshrd.sh boot
            sleep 10
            ./sshrd.sh ssh
            cd ..
            rm -rf SSHRD_Script ~/Documents/palera1n-dfu
            ;;
    esac
}

apt-procursus() {
    info "Bootstrapping procursus and installing apt..."
    case $os in
        Darwin )
            info "Detected $os_name on $arch_check"
            cd "$HOME"
            # Download the bootstrap
            case $arch_check in
                arm64 )
                    sudo curl -L -s https://apt.procurs.us/bootstraps/big_sur/bootstrap-darwin-arm64.tar.zst -o bootstrap.tar.zst
                ;;
                x86_64 )
                    sudo curl -L -s https://apt.procurs.us/bootstraps/big_sur/bootstrap-darwin-amd64.tar.zst -o bootstrap.tar.zst
                ;;
                * )
                    error "Not supported."
                    exit 1
                ;;
            esac
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
            dependencies=("curl" "wget" "usbmuxd" "jq")
            for dependency in "${dependencies[@]}"; do
                if ! command -v "$dependency" >/dev/null 2>&1; then
                    info "Installing dependencies..."
                else
                    echo "" > /dev/null 2>&1 
                fi
            done
            latest_build=$(curl -s "https://api.github.com/repos/palera1n/palera1n/tags" | jq -r '.[].name' | grep -E "v[0-9]+\.[0-9]+\.[0-9]+-beta\.[0-9]+(\.[0-9]+)*$" | sort -V | tail -n 1) 
            REPO_URL="https://api.github.com/repos/palera1n/palera1n/releases"
            BIN_URL=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq --arg uname "$(uname -m)" -r '.[0].assets[] | select(.name == "palera1n-linux-\($uname)") | .browser_download_url')
            LOCK_FILE="$HOME/macscript_palera1n.lock"
            palera1n_get() {
                info "Detected $os_name on $arch_check"
                info "Downloading palera1n version ${latest_build} for $os_name on $arch_check"
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
                info "Downloading palera1n version ${latest_build} for $os_name on $arch_check"
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

submenu_rootful() {
    echo "┌───┬────────────────────────────────┐"
    printf "│ %-2s│ %-30s │\n" "1" "Setup FakeFS"
    printf "│ %-2s│ %-30s │\n" "2" "Setup BindFS"
    printf "│ %-2s│ %-30s │\n" "3" "Boot"
    printf "│ %-2s│ %-30s │\n" "4" "Enter Recovery Mode"
    printf "│ %-2s│ %-30s │\n" "5" "Exit Recovery Mode"
    printf "│ %-2s│ %-30s │\n" "6" "Safe Mode"
    printf "│ %-2s│ %-30s │\n" "7" "Restore RootFS"
    printf "│ %-2s│ %-30s │\n" "8" "DFU Helper"
    printf "│ %-2s│ %-30s │\n" "9" "Back"
    printf "│ %-2s│ %-30s │\n" "10" "Exit"
    echo "└───┴────────────────────────────────┘"
    read -r -p "Enter the number of the option you want to select: " selection
    case $selection in
        1)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -c -f -V
                ;;
                Linux )
                    /usr/bin/palera1n -c -f -V
                ;;
            esac
            ;;
        2)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -f -V -B
                ;;
                Linux )
                    /usr/bin/palera1n -f -V -B
                ;;
            esac
            ;;
        3)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -f -V
                ;;
                Linux )
                    /usr/bin/palera1n -f -V
                ;;
            esac
            ;;
        4)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -E
                ;;
                Linux )
                    /usr/bin/palera1n -E
                ;;
            esac
            
            ;;
        5)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -n
                ;;
                Linux )
                    /usr/bin/palera1n -n
                ;;
            esac
            ;;
        6)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -s -V -f
                ;;
                Linux )
                    /usr/bin/palera1n -s -V -f
                ;;
            esac
            ;;
        7)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n --force-revert -f -V
                ;;
                Linux )
                    /usr/bin/palera1n --force-revert -f -V
                ;;
            esac
            ;;
        8)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -D -f -V
                ;;
                Linux )
                    /usr/bin/palera1n -D -f -V
                ;;
            esac
            ;;
        9) 
            palera1n_main_menu
            ;;
        10)
            exit
            ;;
        *)
            echo "Invalid selection"
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
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -l -V
                ;;
                Linux )
                    /usr/bin/palera1n -l -V
                ;;
            esac
            ;;
        2)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -E
                ;;
                Linux )
                    /usr/bin/palera1n -E
                ;;
            esac
            ;;
        3)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -n
                ;;
                Linux )
                    /usr/bin/palera1n -n
                ;;
            esac
            ;;
        4)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n -D -l -V
                ;;
                Linux )
                    /usr/bin/palera1n -D -l -V
                ;;
            esac
            ;;
        5)
            case $os in
                Darwin )
                    /usr/local/bin/palera1n --force-revert -V
                ;;
                Linux )
                    /usr/bin/palera1n --force-revert -V
                ;;
            esac
            ;;
        6)
            palera1n_main_menu
            ;;
        7)
            exit
            ;;
        *)
            echo "Invalid selection"
            ;;
    esac
}

function palera1n_main_menu {
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
            echo "Invalid selection"
            ;;
    esac
}

main_menu() {
    echo "Welcome to macscript!"
    echo "┌───┬────────────────────────────────┐"
    printf "│ %-2s│ %-30s │\n" "1" "Install checkra1n"
    printf "│ %-2s│ %-30s │\n" "2" "Run the odysseyra1n Script"
    printf "│ %-2s│ %-30s │\n" "3" "Install palera1n"
    case $macos_version_major in
        11|12|13 )
            printf "│ %-2s│ %-30s │\n" "4" "Install Procursus (macOS only)"
            printf "│ %-2s│ %-30s │\n" "5" "SSHRD Script"
            printf "│ %-2s│ %-30s │\n" "6" "Exit"
        ;;
        * )
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
            case $macos_version_major in
                11|12|13 )
                    apt-procursus
                    ;;
                * )
                    error "Not supported."
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