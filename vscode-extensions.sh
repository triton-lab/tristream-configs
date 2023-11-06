#!/bin/bash

set -o errexit
set -o pipefail

# Python
code --install-extension ms-python.python

# IntelliCode
code --install-extension visualstudioexptteam.vscodeintellicode

# Path Intellisense
code --install-extension christian-kohler.path-intellisense

# Docker
code --install-extensionms-azuretools.vscode-docker

# Jupyter
code --install-extension ms-toolsai.jupyter

# Rainbow CSV
code --install-extension mechatroner.rainbow-csv

# ShellCheck
code --install-extension timonwong.shellcheck

# Shell Script Commands
code --install-extension tetradresearch.vscode-h2o


# Copy extensions and configs to /etc/skel
sudo rm -rf /etc/skel/.vscode
sudo cp -rf ~/.vscode /etc/skel/.vscode

sudo rm -rf /etc/skel/.config/Code
sudo mkdir -p /etc/skel/.config/Code
sudo cp -rf ~/.config/Code/User /etc/skel/.config/Code

