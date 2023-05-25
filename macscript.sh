#!/usr/bin/env bash
#variable defenitions
if [ "$(id -u)" -ne 0 ]; then echo "Please run as root." >&2; exit 1; fi
FLAG_FILE=~/Documents/macscript_updates_do_not_delete
LINUX_FLAG_FILE=~/Documents/macscript_updates_do_not_delete

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
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -c -f -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -c -f -V
            fi
            ;;
        2)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -f -V -B
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -f -V -B
            fi
            ;;
        3)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -f -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -f -V
            fi
            ;;
        4)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -E
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -E
            fi
            ;;
        5)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -n
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -n
            fi
            ;;
        6)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -s -V -f
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -s -V -f
            fi 
            ;;
        7)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n --force-revert -f -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n --force-revert -f -V
            fi
            ;;
        8)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -D -f -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -D -f -V
            fi
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

    # Check the user's selection and execute the appropriate command
    case $selection in
        1)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -l -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -l -V
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        2)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -E
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -E
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        3)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -n
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -n
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        4)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n -D -l -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -D -l -V
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        5)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n --force-revert -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n --force-revert -V
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        6)
            echo "Going back to previous menu..."
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
    printf "│ %-2s│ %-30s │\n" "2" "Rootless"
    printf "│ %-2s│ %-30s │\n" "3" "Back"
    printf "│ %-2s│ %-30s │\n" "4" "Exit"
    echo "└───┴────────────────────────────────┘"

# Ask the user for input
    read -r -p "Enter the number of what you want to do: " selection

    # Check the user's selection and execute the appropriate command
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

function b5_submenu_rootful {
        echo "Warning!, You are in the palera1n Beta 5 Menu!"
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
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -c -f -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 -c -f -V
            fi
            ;;
        2)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -f -V -B
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -f -V -B
            fi
            ;;
        3)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -f -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n -f -V
            fi
            ;;
        4)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -E
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 -E
            fi
            ;;
        5)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -n
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 -n
            fi
            ;;
        6)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -s -V -f
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 -s -V -f
            fi 
            ;;
        7)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 --force-revert -f -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 --force-revert -f -V
            fi
            ;;
        8)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -D -f -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 -D -f -V
            fi
            ;;
        9)
            b5_palera1n_main_menu
            ;;
        10)
            exit
            ;;
        *)
            echo "Invalid selection"
            ;;
    esac
}

function b5_submenu_rootless {
        echo "Warning! This is palera1n Beta 5!"
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

    # Check the user's selection and execute the appropriate command
    case $selection in
        1)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -l -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 -l -V
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        2)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -E
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 -E
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        3)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -n
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 -n
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        4)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 -D -l -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 -D -l -V
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        5)
            if [[ $(uname) == "Darwin" ]]; then
                /usr/local/bin/palera1n_b5 --force-revert -V
            elif [[ $(uname) == "Linux" ]]; then
                /usr/bin/palera1n_b5 --force-revert -V
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        6)
            echo "Going back to previous menu..."
            b5_palera1n_main_menu
            ;;
        7)
            exit
            ;;
        *)
            echo "Invalid selection"
            ;;
    esac
}


function b5_palera1n_main_menu {
        echo "Warning!, This is palera1n Beta 5!"
        echo "Welcome to the palera1n submenu!"
    echo "┌───┬────────────────────────────────┐"
    printf "│ %-2s│ %-30s │\n" "1" "Rootful"
    printf "│ %-2s│ %-30s │\n" "2" "Rootless"
    printf "│ %-2s│ %-30s │\n" "3" "Back"
    printf "│ %-2s│ %-30s │\n" "4" "Exit"
    echo "└───┴────────────────────────────────┘"

# Ask the user for input
    read -r -p "Enter the number of what you want to do: " selection

    # Check the user's selection and execute the appropriate command
    case $selection in
        1)
            b5_submenu_rootful
            ;;
        2)
            b5_submenu_rootless
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


#temporarily
function b5_palera1n {
    if [[ $(uname) == "Linux" ]]; then
        if [ -f "$LINUX_FLAG_FILE" ]; then
            echo "Flag file found. Skipping code that should only run once."
        else
            echo "Flag file not found. Running code that should only run once."
        if [ -f "/etc/arch-release" ]; then
            sudo pacman -Sy
            sudo pacman -Syu
            sudo pacman -S curl wget usbmuxd jq
        elif [ -f "/etc/fedora-release" ]; then
            sudo dnf update -y
            sudo dnf upgrade -y
            sudo dnf install -y curl wget usbmuxd jq
        else
            sudo apt update
            sudo apt upgrade -y
            sudo apt install curl wget usbmuxd jq -y
        fi
        # Create the flag file
        sudo touch "$LINUX_FLAG_FILE"
        fi
        curl -L https://github.com/palera1n/palera1n/releases/download/v2.0.0-beta.5/palera1n-linux-$(uname -m) -o /usr/bin/palera1n_b5
        sudo chmod +x /usr/bin/palera1n_b5
        #call main menu function
        b5_palera1n_main_menu
    elif [[ $(uname) == "Darwin" ]]; then
        # Create the flag file
        touch "$FLAG_FILE"
        sudo mkdir -p /usr/local/bin
        echo "Downloading palera1n"        
        sudo curl -L -k https://github.com/palera1n/palera1n/releases/download/v2.0.0-beta.5/palera1n-macos-universal -o /usr/local/bin/palera1n_b5
        sudo chmod +x /usr/local/bin/palera1n_b5
        b5_palera1n_main_menu
    else
        echo "Unknown Operation system, Exiting..."
        exit
    fi
}


function palera1n {
    if [[ $(uname) == "Linux" ]]; then
        if [ -f "$LINUX_FLAG_FILE" ]; then
            echo "Flag file found. Skipping code that should only run once."
        else
            echo "Flag file not found. Running code that should only run once."
            if [ -f "/etc/arch-release" ]; then
                sudo pacman -Sy
                sudo pacman -Syu
                sudo pacman -S curl wget usbmuxd jq
            elif [ -f "/etc/fedora-release" ]; then
                sudo dnf update -y
                sudo dnf upgrade -y
                sudo dnf install -y curl wget usbmuxd jq
            else
                sudo apt update
                sudo apt upgrade -y
                sudo apt install curl wget usbmuxd jq -y
            fi
            sudo mkdir /usr/bin/
            sudo chmod +x /usr/bin/palera1n
            # Create the flag file
            sudo touch "$LINUX_FLAG_FILE"
        fi
        #thx alexia for this url thingy
        REPO_URL="https://api.github.com/repos/palera1n/palera1n/releases"
        LOCK_FILE="$HOME/macscript_palera1n.lock"
        palera1n_get() {
            if [[ $(uname) == "Darwin" ]]; then
                BIN_URL=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq -r '.[0].assets[] | select(.name == "palera1n-macos-universal") | .browser_download_url')
            elif [[ $(uname) == "Linux" ]]; then
                BIN_URL=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq --arg uname "$(uname -m)" -r '.[0].assets[] | select(.name == "palera1n-linux-\($uname)") | .browser_download_url')
            else
                echo "Unsupported, Exiting..."
                exit
            fi
            if [[ $(uname) == "Darwin" ]]; then
                sudo curl -L $BIN_URL -o /usr/local/bin/palera1n
                sudo chmod +x /usr/local/bin/palera1n
            elif [[ $(uname) == "Linux" ]]; then
                sudo curl -L $BIN_URL -o /usr/bin/palera1n
                sudo chmod +x /usr/bin/palera1n
            else
                echo "Unsupported, Exiting..."
                exit
            fi
        }
        #get release from gh
        fetch_latest_version() {
            latest_version=$(curl -s $REPO_URL | grep -o '"tag_name": ".*"' | cut -d'"' -f4)
            echo "$latest_version"
        }

        # update lock with version
        update_lock_file() {
            latest_version=$1
            echo "$latest_version" > $LOCK_FILE
            echo "Lock file updated with version $latest_version"
        }

        # read version from lock file
        current_version=$(cat $LOCK_FILE 2>/dev/null)

        # give me the release 
        latest_version=$(fetch_latest_version)

        # compare versions and update if needed
        if [[ -z "$current_version" ]]; then
            echo "Lock file not found. Creating a new one..."
            update_lock_file "$latest_version"
            palera1n_get
        elif [[ "$current_version" != "$latest_version" ]]; then
            echo "New version available. Updating lock file..."
            update_lock_file "$latest_version"
            palera1n_get
        else
            echo "Lock file is up to date."
        fi
        #call main menu function
        palera1n_main_menu
    elif [[ $(uname) == "Darwin" ]]; then
        echo "Downloading palera1n"        
         REPO_URL="https://api.github.com/repos/palera1n/palera1n/releases"
        LOCK_FILE="$HOME/macscript_palera1n.lock"
        palera1n_get() {
            if [[ $(uname) == "Darwin" ]]; then
                BIN_URL=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq -r '.[0].assets[] | select(.name == "palera1n-macos-universal") | .browser_download_url')
            elif [[ $(uname) == "Linux" ]]; then
                BIN_URL=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq --arg uname "$(uname -m)" -r '.[0].assets[] | select(.name == "palera1n-linux-\($uname)") | .browser_download_url')
            else
                echo "Unsupported, Exiting..."
                exit
            fi
            if [[ $(uname) == "Darwin" ]]; then
                sudo curl -L $BIN_URL -o /usr/local/bin/palera1n
                sudo chmod +x /usr/local/bin/palera1n
            elif [[ $(uname) == "Linux" ]]; then
                sudo curl -L $BIN_URL -o /usr/bin/palera1n
                sudo chmod +x /usr/bin/palera1n
            else
                echo "Unsupported, Exiting..."
                exit
            fi
        }
        #get release from gh
        fetch_latest_version() {
            latest_version=$(curl -s $REPO_URL | grep -o '"tag_name": ".*"' | cut -d'"' -f4)
            echo "$latest_version"
        }

        # update lock with version
        update_lock_file() {
            latest_version=$1
            echo "$latest_version" > $LOCK_FILE
            echo "Lock file updated with version $latest_version"
        }

        # read version from lock file
        current_version=$(cat $LOCK_FILE 2>/dev/null)

        # give me the release 
        latest_version=$(fetch_latest_version)

        # compare versions and update if needed
        if [[ -z "$current_version" ]]; then
            echo "Lock file not found. Creating a new one..."
            update_lock_file "$latest_version"
            palera1n_get
        elif [[ "$current_version" != "$latest_version" ]]; then
            echo "New version available. Updating lock file..."
            update_lock_file "$latest_version"
            palera1n_get
        else
            echo "Lock file is up to date."
        fi
        palera1n_main_menu
    else
        echo "Unknown Operation system, Exiting..."
        exit
    fi
}

# Function to display checkra1n 
function checkra1n {
    if [[ $(uname) == "Linux" ]]; then
        if [ -f "$LINUX_FLAG_FILE" ]; then
                echo "Flag file found. Skipping code that should only run once."
            else
                echo "Flag file not found. Running code that should only run once."
            if [[ $(uname -m) == "x86_64" ]]; then
                sudo curl -L -k https://assets.checkra.in/downloads/linux/cli/x86_64/dac9968939ea6e6bfbdedeb41d7e2579c4711dc2c5083f91dced66ca397dc51d/checkra1n -o /usr/bin/checkra1n
            elif [[ $(uname -m) == "arm" ]]; then
                sudo curl -L -k https://assets.checkra.in/downloads/linux/cli/arm/ff05dfb32834c03b88346509aec5ca9916db98de3019adf4201a2a6efe31e9f5/checkra1n -o /usr/bin/checkra1n
            elif [[ $(uname -m) == "arm64" ]]; then
                sudo curl -L -k https://assets.checkra.in/downloads/linux/cli/arm64/43019a573ab1c866fe88edb1f2dd5bb38b0caf135533ee0d6e3ed720256b89d0/checkra1n -o /usr/bin/checkra1n
            elif [[ $(uname -m) == "i486" ]]; then
                sudo curl -L -k https://assets.checkra.in/downloads/linux/cli/i486/77779d897bf06021824de50f08497a76878c6d9e35db7a9c82545506ceae217e/checkra1n -o /usr/bin/checkra1n
            else
                echo "Unsupported operating system"
                exit
            fi
              echo "Please note that the checkra1n team or me is not viable for any damage you might cause to your device"
              echo "In this next screen, you need to enable untested iOS versions if you are on an iOS version higher than 14.5.1"
              while [[ ! "$choice" =~ ^[yYnN]$ ]]
          do
              read -r -p "Do you want to continue? (Y/n) " choice
          done
              # Handle user input
          case "$choice" in
              y|Y)
                  echo "Continuing..."
                ;;
            n|N)
                echo "Exiting..."
                exit
                ;;
        esac
            sudo chmod +x /usr/bin/checkra1n
            sudo /usr/bin/checkra1n -t -V
            # Create the flag file
            touch "$LINUX_FLAG_FILE"
        fi
    elif [[ $(uname) == "Darwin" ]]; then
        sudo curl -L -k https://assets.checkra.in/downloads/macos/754bb6ec4747b2e700f01307315da8c9c32c8b5816d0fe1e91d1bdfc298fe07b/checkra1n%20beta%200.12.4.dmg -o /usr/local/bin/checkra1n.dmg
        sudo hdiutil attach /usr/local/bin/checkra1n.dmg
        # Prompt user for input
        echo "In this next screen, you need to enable untested iOS versions if you are on an iOS version higher than 14.5.1"
        echo "Please note that the checkra1n team or me is not viable for any damage you might cause to your device"
        read -r -p "Do you want to continue? (y/n) " choice

        # Loop to handle invalid input
        while [[ ! "$choice" =~ ^[yYnN]$ ]]
        do
            read -r -p "Please enter y or n: " choice
        done

            # Handle user input
        case "$choice" in
            y|Y)
                echo "Continuing..."
            if [[ $(uname -r) == "20."* ]]; then
                sudo /Volumes/checkra1n\ beta\ 0.12.4\ 1/checkra1n.app/Contents/MacOS/checkra1n -V -t 
            elif [[ $(uname -r) == "21."* ]]; then
                sudo /Volumes/checkra1n\ beta\ 0.12.4\ 1/checkra1n.app/Contents/MacOS/checkra1n -V -t
            else
                sudo /Volumes/checkra1n\ beta\ 0.12.4/checkra1n.app/Contents/MacOS/checkra1n -V -t 
            fi
                ;;
            n|N)
                echo "Exiting..."
                exit
                ;;
        esac
    fi
        if [ "$version" -ge 20 ]; then
            sudo hdiutil detatch /Volumes/checkra1n\ beta\ 0.12.4
        else
            sudo hdiutil detach /Volumes/checkra1n\ beta\ 0.12.4\ 1/
        fi
        sudo rm -rf /usr/local/bin/checkra1n.dmg 
}

function sshrd {
    if [[ $(uname) == "Darwin" ]]; then
        echo "Please verify that you have a checkm8 device before doing this (iPhone 5s - iPhone X)"
                while [[ ! "$choice" =~ ^[yYnN]$ ]]
            do
                read -r -p "Do you want to continue? (Y/n) " choice
            done
            case "$choice" in
                y|Y)
                    echo "Continuing..."
                    if [[ -f FLAG_FILE ]]; then
                        echo "Flag file not detected, running code that should only be run once."
                        xcode-select –install
                    else
                        echo "Flag file detected, continuing..."
                    fi
                    git clone https://github.com/verygenericname/SSHRD_Script --recursive && cd SSHRD_Script
                    sudo chmod +x ./sshrd.sh
                    echo "The device will now be placed in recovery mode."
                    url=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq -r '.[0].assets[] | select(.name == "palera1n-macos-universal") | .browser_download_url')
                    curl -L "$url" -o ~/Documents/palera1n-dfu
                    echo "Now palera1n will help you to place your device in DFU mode"
                    chmod +x ~/Documents/palera1n-dfu
                    ~/Documents/palera1n-dfu -D
                    sudo rm -rf ~/Documents/palera1n-dfu
                    read -r -p "What iOS version is the device currently running? (it does not have to the exact version, just something close enough, example 15.2)" ios_version_sshrd
                    ./sshrd.sh $ios_version_sshrd
                    ./sshrd.sh boot
                    sleep 15
                    ./sshrd.sh ssh
                    cd ..
                    rm -rf SSHRD_Script
                    ;;
                n|N)
                    echo "Exiting..."
                    exit
                    ;;
            esac
    elif [[ $(uname) == "Linux" ]]; then
        echo "Please verify that you have a checkm8 device before doing this (iPhone 5s - iPhone X)"
            while [[ ! "$choice" =~ ^[yYnN]$ ]]
            do
                read -r -p "Do you want to continue? (Y/n) " choice
            done
            case "$choice" in
                y|Y)
                    echo "Continuing..."
                    if [[ -f LINUX_FLAG_FILE ]]; then
                        echo "Flag file not detected, running code that should only be run once."
                        if [[ -f /etc/arch-release ]]; then
                            sudo pacman -S git
                        elif [[ -f /etc/fedora-release ]]; then
                            sudo rpm install git
                        else
                            sudo apt-get update
                            sudo apt-get install git
                        fi
                    else
                        echo "Flag file detected, skipping code that should only be run once"
                    fi
                    git clone https://github.com/verygenericname/SSHRD_Script --recursive && cd SSHRD_Script
                    sudo chmod +x ./sshrd.sh
                    echo "The device will now be placed in recovery mode."
                    url=$(curl -s 'https://api.github.com/repos/palera1n/palera1n/releases' | jq --arg uname "$(uname -m)" -r '.[0].assets[] | select(.name == "palera1n-linux-\($uname)") | .browser_download_url')
                    curl -L "$url" -o ~/Documents/palera1n-dfu
                    echo "Now palera1n will help you to place your device in DFU mode"
                    chmod +x ~/Documents/palera1n-dfu
                    ~/Documents/palera1n-dfu -D
                    sudo rm -rf ~/Documents/palera1n-dfu
                    read -r -p "What iOS version is the device currently running? (it does not have to the exact version, just something close enough, example 15.2)" ios_version_sshrd
                    ./sshrd.sh $ios_version_sshrd
                    ./sshrd.sh boot
                    ./sshrd.sh ssh
                    cd ..
                    rm -rf SSHRD_Script ~/Documents/palera1n-dfu
                    ;;
                n|N)
                    echo "Exiting..."
                    exit
                    ;;
            esac
    else
        echo "Unsupported, exiting..."
        exit
    fi
}
#procurusussusuusussusuus installation on macos
function apt-procursus {
        if [[ $(uname) == "Darwin" ]]; then
            read -r -p "Do you want to bootstrap procursus and install apt? (y/n)" awnser
        if [[ $awnser =~ ^[yY]$ ]]; then
            echo "Bootstrapping procursus and installing apt, please wait..."
        if [[ $(uname -m) == "arm64" ]]; then
            curl -L https://apt.procurs.us/bootstraps/big_sur/bootstrap-darwin-arm64.tar.zst -o bootstrap.tar.zst
        else
            curl -L https://apt.procurs.us/bootstraps/big_sur/bootstrap-darwin-amd64.tar.zst -o bootstrap.tar.zst
        fi
        curl -LO https://cameronkatri.com/zstd
        chmod +x zstd
        ./zstd -d bootstrap.tar.zst
        sudo rm -rfv /opt/procursus
        sudo tar -xpkf bootstrap.tar -C /
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
        echo "Installation Complete! Be sure to restart your terminal!"
            fi
        else
            echo "Not Supported"
        fi
}

function odysseyra1n {
    if [[ $(uname) == "Darwin" ]]; then
        if ! command -v brew &> /dev/null
    then
        echo "brew not found, installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "brew is already installed, continuing..."
    fi
     sudo -u $SUDO_USER brew install libusbmuxd
     echo "Note that me or the checkra1n/odysseyra1n team are not responsible for any damage you may cause to your device."
     echo "For odysseyra1n to work, you have to be jailbroken via checkra1n in the first option of the main menu."
     echo "For odysseyra1n to work, you must NOT have opened the checkra1n app after jailbreaking, if you have done so, restore rootFS and try again"
              while [[ ! "$choice" =~ ^[yYnN]$ ]]
          do
              read -r -p "Do you want to continue? (Y/n) " choice
          done
              # Handle user input
          case "$choice" in
              y|Y)
                  echo "Continuing..."
                  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/coolstar/Odyssey-bootstrap/master/procursus-deploy-linux-macos.sh)"
                ;;
            n|N)
                echo "Exiting..."
                exit
                ;;
        esac

    elif [[ $(uname) == "Linux" ]]; then
        if [[ -f "$LINUX_FLAG_FILE" ]]; then
            echo "Flag file not detected, running code that should only be run once..."
            if [ -f "/etc/arch-release" ]; then
                sudo pacman -S libusbmuxd
            else
                sudo apt-get update
                sudo apt-get upgrade -y
                sudo apt-get install -y libusbmuxd-tools
            fi
        else
            echo "Flag file detected, skipping code that should only be run once..."
        fi
             echo "Note that me or the checkra1n/odysseyra1n team are not responsible for any damage you may cause to your device."
            echo "For odysseyra1n to work, you have to be jailbroken via checkra1n in the first option of the main menu."
            echo "For odysseyra1n to work, you must NOT have opened the checkra1n app after jailbreaking, if you have done so, restore rootFS and try again"
              while [[ ! "$choice" =~ ^[yYnN]$ ]]
          do
              read -r -p "Do you want to continue? (Y/n) " choice
          done
              # Handle user input
          case "$choice" in
              y|Y)
                  echo "Continuing..."
                  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/coolstar/Odyssey-bootstrap/master/procursus-deploy-linux-macos.sh)"
                ;;
            n|N)
                echo "Exiting..."
                exit
                ;;
        esac
    else
        echo "Unrecognized operating system"
    fi    
}


function main_menu {
    echo "Welcome to macscript!"
    echo "┌───┬────────────────────────────────┐"
    printf "│ %-2s│ %-30s │\n" "1" "Install checkra1n"
    printf "│ %-2s│ %-30s │\n" "2" "Run the odysseyra1n Script"
    printf "│ %-2s│ %-30s │\n" "3" "Install palera1n"
    printf "│ %-2s│ %-30s │\n" "4" "Install palera1n (Beta 5)"
    if [[ $(uname -r) == "20."* ]]; then
        printf "│ %-2s│ %-30s │\n" "5" "Install Procursus (macOS only)"
    elif [[ $(uname -r) == "21."* ]]; then
        printf "│ %-2s│ %-30s │\n" "5" "Install Procursus (macOS only)"
    elif [[ $(uname -r) == "22."* ]]; then
        printf "│ %-2s│ %-30s │\n" "5" "Install Procursus (macOS only)"
    fi
    printf "│ %-2s│ %-30s │\n" "6" "SSHRD Script"
    printf "│ %-2s│ %-30s │\n" "7" "Exit"
    echo "└───┴────────────────────────────────┘"

    # Ask the user for input
    read -p "Enter the number of what you want to do: " selection

    # Check the user's selection and execute the appropriate command
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
            b5_palera1n
            ;;
        5)
            if [[ $(uname -r) == "20."* ]]; then
                apt-procursus
            elif [[ $(uname -r) == "21."* ]]; then
                apt-procursus
            elif [[ $(uname -r) == "22."* ]]; then
                apt-procursus
            else
                echo "Not supported, exiting..."
                exit
            fi
            ;;
        6)
            sshrd
            ;;
        7)
            echo "Exiting..."
            exit
            ;;
        *)
            echo "Invalid selection"
            ;;
    esac
}
main_menu
