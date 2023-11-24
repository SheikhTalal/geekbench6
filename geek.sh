#!/bin/bash

# Secure Geekbench-6.1.0 installer
# https://github.com/SheikhTalal/geekbench6

# Check if the script is run as the superuser
if [ "$EUID" -ne 0 ]; then
    echo "This script requires superuser privileges. Please run as root or using sudo."
    exit 1
fi

# Function to check and install packages on Debian-based systems
install_on_debian() {
    sudo apt-get update
    sudo apt-get install -y sudo wget curl
}

# Function to check and install packages on CentOS-based systems
install_on_centos() {
    sudo yum install -y sudo wget curl
}

# Function to check and install packages on Fedora-based systems
install_on_fedora() {
    sudo dnf install -y sudo wget curl
}

# Function to check and install packages on Arch Linux
install_on_arch() {
    sudo pacman -Sy --noconfirm sudo wget curl
}

# Check if sudo is installed
if ! command -v sudo &>/dev/null; then
    echo "sudo is not installed. Installing..."
    # Check the distribution and call the appropriate function
    if [ -f /etc/debian_version ]; then
        install_on_debian
    elif [ -f /etc/redhat-release ]; then
        install_on_centos
    elif [ -f /etc/fedora-release ]; then
        install_on_fedora
    elif [ -f /etc/arch-release ]; then
        install_on_arch
    else
        echo "Unsupported distribution. Please install sudo manually."
        exit 1
    fi
else
    echo "sudo is already installed."
fi

# Check if wget is installed
if ! command -v wget &>/dev/null; then
    echo "wget is not installed. Installing..."
    sudo apt-get install -y wget || sudo yum install -y wget || sudo dnf install -y wget || sudo pacman -Sy --noconfirm wget
else
    echo "wget is already installed."
fi

# Check if curl is installed
if ! command -v curl &>/dev/null; then
    echo "curl is not installed. Installing..."
    sudo apt-get install -y curl || sudo yum install -y curl || sudo dnf install -y curl || sudo pacman -Sy --noconfirm curl
else
    echo "curl is already installed."
fi

echo "Installation complete."

wget https://cdn.geekbench.com/Geekbench-6.1.0-Linux.tar.gz && tar -zxvf Geekbench-6.1.0-Linux.tar.gz && cd Geekbench-6.1.0-Linux && ./geekbench_x86_64

exit
