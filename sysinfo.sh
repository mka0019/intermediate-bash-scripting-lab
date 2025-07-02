#!/bin/bash



# =============================
# HELP COMMAND LINE FEATURE  
# =============================
if [[ "$1" == "-h" || "$1" == "--help" ]]; then 
#this will check if in the command line -h or --help was typed, then it will run the below
# if none of the above in the command line, then it runs the rest of the code 
# basically, we usually check what a user inputs after we ask the user for one, but this checking for arguments from the beginning 
    echo "----------------------------------"
    echo "HELP - What This Script Does"
    echo "----------------------------------"
    echo "This script provides system monitoring tools:"
    echo
    echo "1: Show system info –> Displays the  OS, hostname, uptime, etc."
    echo "2: Show disk usage –> Displays the available disk space on all mounted filesystems"
    echo "3: Show current users –> Show all users currently logged into the system and what apps each user is using."
    echo "4: Show top processes –> Displays top the  most CPU-intensive processes"
    echo "6: Exit –> Short and sweet exit"
    echo
    echo "Options:"
    echo "  ./sysinfo.sh       Launch the interactive menu"
    echo "  ./sysinfo.sh -h    Show this help message only"
    echo "----------------------------------"
    exit 0
fi

#When no arguments are passed in the above script, then the below starts with the welcome message. 




#+++++++++++++++++++
#FUNCTIONS
#+++++++++++++++++++

# FUNCTION 1 >> It will display the OS NAME, VERSION, HOSTNAME, KERNEL VERSION, UPTIME
show_system_info() {
    echo "Operating System: $(uname -o)" #uname -o --> displays OS name
    get_os_info_because_mac_is_weird #see below
    echo "Hostname: $(hostname)" #displays hostname 
    echo "Kernel Version: $(uname -r)" # displays kernel version
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"  # fallback for macOS> cause it doesn't want to be normal like the rest
    echo "------------------------------"
}

# FUNCTION 1.5 > HOW TO GET THE MAC OS VERSION TO SHOW TO UP
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

#+++++++++++++++++++

#FUCNTION 2 >> to dispaly disk usage
show_disk_usage() {
    df -h #short and sweet command that displays the disk space. -h represents the filesystem to be shown ins human-readable format. 
}

#+++++++++++++++++++

#FUCNTION 3 >> displays the current users and what apps each user has running 
show_current_users() {
    who > lists all the users currently logged into the sytsem. 
    echo
    echo "Apps being run by currently logged-in users:"
    #because as we know macOS is special, we had to add more lines of code
    #similar to above, if we have darwin macos then the first ps will trun, otherwise we got the normal script
    if [[ "$(uname)" == "Darwin" ]]; then 
        # macOS compatible ps:
        ps -axo user,pid,comm | grep -v "^root" | column -t
    else
        # Linux ps:
        ps -eo user,pid,comm --sort=user | grep -v "^root" | column -t
    fi

    #note to self, make a list a of all the keywords from above. 
    
}

#+++++++++++++++++++

#FUNCTION 4 >> show_top_processes >> will show the top 5 most CPU intensive processes
show_top_processes() {
    echo "----------------------------------"
    echo "TOP 5 CPU-INTENSIVE PROCESSES - $current_time"
    echo "----------------------------------"
    printf "+------+--------+--------+----------------+\n"
    printf "| PID  | USER   | CPU%%   | COMMAND        |\n"
    printf "+------+--------+--------+----------------+\n"

    if [[ "$(uname)" == "Darwin" ]]; then
        ps -arcwwwxo pid,user,%cpu,comm | head -n 6 | tail -n 5 | awk '{printf "| %-4s | %-6s | %-6s | %-14s |\n", $1, $2, $3, $4}'
    else
        ps -eo pid,user,%cpu,comm --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "| %-4s | %-6s | %-6s | %-14s |\n", $1, $2, $3, $4}'
    fi

    printf "+------+--------+--------+----------------+\n"
    echo "----------------------------------"
}



# Display a title
    echo ===============================
    echo WELCOME TO THE SYSTEM MENU!!!!
    echo ===============================


# Display menu options
echo "Welcome, select one of the following options using the number keys:"
echo "1: Show System Info"
echo "2: Show Disk Usage"
echo "3: Show Current Users"
echo "4: Show Top Processes"
echo "5: Exit"
echo "For help on what each process does type, exit and in command line type > ./sysinfo.sh -h"

# Prompt user for input
read -p "Enter your option [1-5]:" option

# Create an if/elif/else structure to handle the different menu options.s
if [ "$option" == "1" ]; then
    echo "You selected Option 1: Show System Info"
     show_system_info
elif [ "$option" == "2" ]; then
    echo "You selected Option 2: Show Disk Usage"
    show_disk_usage
elif [ "$option" == "3" ]; then
    echo "You selected Option 3: Show Current Users"
    show_current_users
elif [ "$option" == "4" ]; then
    echo "You selected Option 4: Show Top Processes"
    show_top_processes   
elif [ "$option" == "5" ]; then
    echo "You've selected: Exit"
    echo "Goodbye!"
    exit 0
else
    echo "Invalid selection. Please select options between 1-5"
fi
