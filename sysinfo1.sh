#!/bin/bash


# Display a title
echo " ======= System Info Menu Tool !!!!!!!  ======="


#functions
show_system_info() {
    echo "Operating System: $(uname -o)" #uname -o --> displays OS name
    get_os_info_because_mac_is_weird #see below
    echo "Hostname: $(hostname)" #displays hostname 
    echo "Kernel Version: $(uname -r)" # displays kernel version
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"  # fallback for macOS> cause it doesn't want to be normal like the rest
    echo "------------------------------"
}

# with the power of insane mamount of googling, the below function will check, is the OS Darwin, cause Darwin = macOS.
# if yes then it will display the verson with the echo
# if not then it linux/windows
# if not Darwin-macOS, its some random mac os then its unknown and we don't care enough to find out lol 
get_os_info_because_mac_is_weird() {
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "OS: macOS $(sw_vers -productVersion)"
    elif [[ -f /etc/os-release ]]; then
        echo "OS: $(grep '^PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '"')"
    else
        echo "OS: Unknown"
    fi
}

#function to dispaly disk usage
show_disk_usage() {
    df -h #short and sweet command that displays the disk space. -h represents the filesystem to be shown ins human-readable format. 
}

# function displays the current users and what apps each user has running 
show_current_users() {
    who > lists all the users currently logged into the sytsem. 
    echo
    echo "Apps being run by currently logged-in users:"
    #because as we know macOS is special, we had to add more lines of code
    #similar to above, if we have darwin macos then the first ps will trun, otherwise we got the normal script
    if [[ "$(uname)" == "Darwin" ]]; then. 
        # macOS compatible ps:
        ps -axo user,pid,comm | grep -v "^root" | column -t
    else
        # Linux ps:
        ps -eo user,pid,comm --sort=user | grep -v "^root" | column -t
    fi

    #note to self, make a list a of all the keywords from above. 
    
}

# Display menu options
echo "Welcome, select one of the following options using the number keys:"
echo "1: Show System Info"
echo "2: Show Disk Usage"
echo "3: Show Current Users"
echo "4: Exit"

# Prompt user for input
read -p "Enter your choice [1-4]: " choice

# Create an if/elif/else structure to handle the different menu options.
if [ "$choice" == "1" ]; then
    echo "You selected Option 1: Show System Info"
     show_system_info
elif [ "$choice" == "2" ]; then
    echo "You selected Option 2: Show Disk Usage"
    show_disk_usage
elif [ "$choice" == "3" ]; then
    echo "You selected Option 3: Show Current Users"
    show_current_users
elif [ "$choice" == "4" ]; then
    echo "Exiting... Goodbye!"
    exit 0
else
    echo "Invalid selection. Please select options between 1-4"
fi
