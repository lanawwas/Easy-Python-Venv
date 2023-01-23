# easy-venv-bash

here's a bash script that reads the system's Python versions and prompts the user to select which one to use for the virtual environment:


This script prompts the user for the name of the virtual environment and then it uses ls to list all the files in the /usr/bin/ directory that contain the word "python" and filters out some files that are not needed, then it prompts the user to select which version of Python to use from the list of available versions.

Then it uses the selected version of python to create the virtual environment and activates it.

Please note that the path to the python version may vary depending on your system. This script assumes that the python versions are located in the /usr/bin directory.

You can run this script by calling bash create_venv.sh on the command line, it will create the virtual environment with the specified name and python version, and activate it.
