## Description
This project provides a collection of shell scripts to simplify the installation of common server applications. Designed for ease of use, these scripts automate the setup process for applications like Docker and Memos. All scripts are tailored for **Ubuntu-based systems** and leverage **`sudo`** for privileged operations.
## Features
- One-click setup for popular server applications.
- Lightweight and user-friendly.
- Handles dependencies and configurations automatically.
- Modular approach: Each script targets a specific application.
- Error handling and clear user feedback.
---
## Installation Guide

Follow these steps to use the scripts for setting up applications on your Ubuntu server.
### 1. Download the Scripts

Clone the repository or download the specific script you need:
```
https://github.com/FiOS-repo/Installations-Scripts.git
cd Installations-Scripts
```
### 2. Make the Script Executable

Before running a script, you need to give it execution permissions. Replace `<script-name.sh>` with the script you want to use, e.g., `install-memos.sh`:
```
sudo ./<script-name.sh>
```
### 3. Run the Script

Execute the script with `sudo` to ensure the necessary permissions are available:
```
sudo ./<script-name.sh>
```
### Example: Installing Memos

If you want to install **Memos**, run:
```
chmod +x memos.sh 
sudo ./memos.sh
```
---
## Current Scripts

| Script Name         | Description                        |
| ------------------- | ---------------------------------- |
| `memos.sh`          | Installs Docker and deploys Memos. |
| `wikijs.sh`         | Installs Docker and deploys WikiJS. |
| `nextcloud.sh`      | Installs Docker and deploys Nextcloud. |
| _More Coming Soon!_ | Scripts for other applications.    |

---
## Contribution

Feel free to contribute additional scripts or enhance the existing ones! Here's how you can contribute:

1. Fork the repository.
2. Add your script to the project.
3. Create a pull request with a clear description.
---
## Disclaimer

These scripts are provided as-is. While they are designed for reliability, use them at your own risk. Always test in a development environment before deploying to production.