#!/bin/bash

# VPS Manager by AndrewON Version 1.1

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Define backup directory
BACKUP_DIR="$HOME/backup_vps"

# Function to check resources
check_resources() {
    echo -e "${CYAN}==========================${NC}"
    echo -e "${CYAN} System Information as of $(date)${NC}"
    echo -e "${CYAN}==========================${NC}"
    echo -e "${WHITE}System load: $(cat /proc/loadavg | awk '{print $1}')\t\tProcesses: $(ps aux | wc -l)${NC}"
    echo -e "${WHITE}Disk Usage: $(df -h / | grep / | awk '{print $3 " / " $2 " (" $5 ")"}')${NC}"
    echo -e "${WHITE}Memory Usage: $(free -h | awk '/Mem/{print $3 "/" $2}')${NC}"
    echo -e "${WHITE}Swap Usage: $(free -h | awk '/Swap/{print $3 "/" $2}')${NC}"
    echo -e "${WHITE}IPv4 Address: $(hostname -I | awk '{print $1}')${NC}"
    echo -e "${CYAN}==========================${NC}"
}

# Function to backup VPS
backup_vps() {
    echo -e "${GREEN}Backing up VPS...${NC}"
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
    fi

    # Backup files and directories
    cp -r /var/www "$BACKUP_DIR/var_www" 2>/dev/null
    cp -r /etc/pterodactyl "$BACKUP_DIR/etc_pterodactyl" 2>/dev/null
    cp -r /var/lib/pterodactyl "$BACKUP_DIR/var_lib_pterodactyl" 2>/dev/null

    # Backup databases (Example for MySQL; adjust as necessary)
    mysqldump --all-databases > "$BACKUP_DIR/all_databases.sql" 2>/dev/null
    echo -e "${GREEN}Backup completed successfully!${NC}"
}

# Function to restore VPS from backup
restore_vps() {
    echo -e "${YELLOW}Restoring VPS from backup...${NC}"
    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${RED}Backup not found. Please take a backup first.${NC}"
        return
    fi

    # Restore files and directories
    cp -r "$BACKUP_DIR/var_www"/* /var/www/ 2>/dev/null
    cp -r "$BACKUP_DIR/etc_pterodactyl"/* /etc/pterodactyl/ 2>/dev/null
    cp -r "$BACKUP_DIR/var_lib_pterodactyl"/* /var/lib/pterodactyl/ 2>/dev/null

    # Restore databases (Example for MySQL; adjust as necessary)
    mysql < "$BACKUP_DIR/all_databases.sql" 2>/dev/null
    echo -e "${GREEN}Restore completed successfully!${NC}"
}

# Function to reset VPS
reset_vps() {
    echo -e "${RED}Resetting VPS settings...${NC}"
    
    # Notify the user before resetting
    echo -e "${CYAN}This will not disconnect your session, but some processes may be affected.${NC}"
    sleep 2

    echo -e "${CYAN}Killing non-essential processes...${NC}"

    # Kill non-essential processes
    essential_processes=("bash" "systemd" "sshd" "mysql" "nginx")
    
    ps aux | awk '{print $2,$11}' | while read pid cmd; do
        if [[ ! " ${essential_processes[*]} " =~ " ${cmd} " ]]; then
            echo -e "${RED}Killing process $pid: $cmd${NC}"
            kill -9 "$pid" 2>/dev/null
        fi
    done

    # Clear unnecessary files
    echo -e "${YELLOW}Clearing temporary files and logs...${NC}"
    rm -rf /tmp/* 2>/dev/null
    rm -rf /var/log/* 2>/dev/null

    # Uninstall Wings and Pterodactyl Panel
    echo -e "${YELLOW}Uninstalling Pterodactyl Wings and Panel...${NC}"
    systemctl stop wings
    systemctl disable wings
    apt-get remove --purge -y wings pterodactyl-panel 2>/dev/null

    # Reset databases (This will delete non-default ones; be cautious)
    mysql -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)" | xargs -I {} mysql -e "DROP DATABASE {};" 2>/dev/null

    echo -e "${GREEN}Reset completed successfully!${NC}"
}

# Function to remove user-installed commands
remove_installed_cmds() {
    echo -e "${YELLOW}Removing user-installed commands...${NC}"
    # List of commands to remove
    commands_to_remove=("screenfetch" "htop" "vim" "nano")

    for cmd in "${commands_to_remove[@]}"; do
        if command -v "$cmd" >/dev/null; then
            echo -e "${RED}Removing $cmd...${NC}"
            apt-get remove -y "$cmd" 2>/dev/null
        fi
    done

    echo -e "${GREEN}User-installed commands removed successfully!${NC}"
}

# Function to show credits
show_credits() {
    echo -e "${CYAN}==========================${NC}"
    echo -e "${CYAN}Created by AndrewON - Version 1.1${NC}"
    echo -e "${CYAN}==========================${NC}"
}

# Main program
while true; do
    check_resources
    echo -e "${CYAN}==========================${NC}"
    echo -e "${CYAN}        VPS MANAGER        ${NC}"
    echo -e "${CYAN}        BY ANDREWON        ${NC}"
    echo -e "${CYAN}         VERSION 1.1       ${NC}"
    echo -e "${CYAN}==========================${NC}"
    echo -e "${WHITE}  1) Reset VPS${NC}"
    echo -e "${WHITE}  2) Backup VPS${NC}"
    echo -e "${WHITE}  3) Restore VPS from Backup${NC}"
    echo -e "${WHITE}  4) Remove User-Installed Commands${NC}"
    echo -e "${WHITE}  5) CREDITS${NC}"
    echo -e "${WHITE}  6) EXIT${NC}"
    echo -e "${CYAN}==========================${NC}"
    read -p "Select an option (1-6): " option

    case $option in
        1) 
            reset_vps
            ;;
        2) 
            backup_vps
            ;;
        3) 
            restore_vps
            ;;
        4) 
            remove_installed_cmds
            ;;
        5) 
            show_credits
            ;;
        6) 
            break
            ;;
        *) 
            echo -e "${RED}Invalid option. Please select 1-6.${NC}"
            ;;
    esac
    echo -e "${CYAN}Press Enter to continue...${NC}"
    read
done