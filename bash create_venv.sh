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
                    else
        echo "Python installation was skipped. Exiting..."
        exit 1
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
