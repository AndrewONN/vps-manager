# VPS Manager

**VPS Manager** is a powerful bash script designed to streamline the management of your VPS (Virtual Private Server). This tool provides various functionalities to help you maintain, backup, restore, and reset your server easily and efficiently.

## Features

- **Resource Monitoring**: Check system load, memory usage, disk usage, and more.
- **Backup Functionality**: Create backups of critical directories and databases.
- **Restore Capability**: Restore your VPS from the latest backup with ease.
- **VPS Reset**: Quickly reset VPS settings, clear unnecessary files, and terminate non-essential processes.
- **Remove User-installed Commands**: Clean up user-installed commands for a more streamlined server environment.
- **Easy Installation**: Simple one-liner command to download and execute the script directly from GitHub.

## Installation

To install and run the `vps-manager` script, simply use the following command in your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/AndrewONN/vps-manager/main/vps_management.sh -o vps_management.sh && chmod +x vps_management.sh && ./vps_management.sh
```

### Step-by-step Breakdown:
1. **Download the Script**: This command fetches the latest version of the script from the GitHub repository.
2. **Set Executable Permissions**: Makes the script executable.
3. **Execute the Script**: Runs the script to begin using the VPS Manager functionalities.

## Usage

After running the script, you'll be presented with a menu that allows you to choose from the following options:

1. Reset VPS
2. Backup VPS
3. Restore VPS from Backup
4. Remove User-Installed Commands
5. View Credits
6. Exit

Simply enter the corresponding number to select an option.

## Important Notes

- **Backup**: Ensure you take regular backups of your data before performing reset operations.
- **Permissions**: You may need superuser privileges (sudo) to execute some commands within the script.

## Author

Created by [AndrewONN](https://github.com/AndrewONN)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
