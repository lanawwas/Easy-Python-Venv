#!/bin/bash

# Author: Laith Abu-Nawwas
# Co-Author: ChatGPT Jan 9 Version

# Check if Python is installed
if ! command -v python &> /dev/null; then
    echo "Python is not installed on this system."
    read -p "Do you want to install it? (y/n): " install_python
    if [[ $install_python == "y" ]]; then
        if [ "$(uname)" == "Darwin" ]; then
            # MacOS
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
            brew install python
        elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
            # Linux
            if [ -x "$(command -v apt-get)" ]; then
                # Debian based distro
                sudo apt-get install python
            elif [ -x "$(command -v dnf)" ]; then
                # Fedora
                sudo dnf install python
            elif [ -x "$(command -v yum)" ]; then
                # Red Hat based distro
                sudo yum install python
            else
                echo "This Linux distribution is not supported. Please install Python manually."
            fi
        fi
    else
        echo "Python installation was skipped. Exiting..."
        exit 1
    fi
fi

# Check if a virtual environment is already activated
if [ -n "$VIRTUAL_ENV" ]; then
    read -p "A virtual environment is already activated, do you want to use it? (y/n): " use_existing
    if [[ $use_existing == "y" ]]; then
        echo "Using existing virtual environment: $VIRTUAL_ENV"
        exit 0
    fi
fi

echo "Enter the name of the virtual environment:"
read venv_name

# Get the available Python versions
versions=($(ls /usr/bin/ | grep python | grep -v -e 'config' -e 'mackup'))

# Print the available versions and prompt the user to select one
echo "Select a Python version to use:"
select version in "${versions[@]}"; do
    python_version="${version}"
    break
done

# Create the virtual environment
"/usr/bin/${python_version}" -m venv ${venv_name}

# Activate the virtual environment
source ${venv_name}/bin/activate

echo "Virtual environment ${venv_name} has been created and activated using ${python_version}."

# Check if pip is installed
if ! command -v pip &> /dev/null; then
    echo "pip is not installed on this system."
    read -p "Do you want to install it? (y/n): " install_pip
    if [[ $install_pip == "y" ]]; then
        echo "Installing pip..."
        "${venv_name}/bin/python" -m ensurepip --upgrade
    else
        echo "pip installation was skipped. Skipping package installation."
        exit 1
    fi
fi

# Check if the system has internet connection
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    echo "Internet connection detected."
    # Ask the user if they want to install packages from a requirements.txt file
    read -p "Do you want to install packages from a requirements.txt file? (y/n): " install_from_file
    if [[ $install_from_file == "y" ]]; then
        read -p "Enter the path to the requirements.txt file: " requirements_path
        if [ -f "$requirements_path" ]; then
            echo "Installing packages from $requirements_path"
            pip install -r $requirements_path
        else
            echo "$requirements_path does not exist or is not a file. Skipping package installation."
        fi
    fi
else
    echo "No internet connection detected."
    read -p "Do you want to install packages from a local path? (y/n): " install_from_local
    if [[ $install_from_local == "y" ]]; then
        read -p "Enter the path to the local packages directory: " local_path
        if [ -d "$local_path" ]; then
            echo "Installing packages from $local_path"
            pip install --no-index --find-links=$local_path -r $requirements_path
        else
            echo "$local_path does not exist or is not a directory. Skipping package installation."
        fi
    fi
fi
