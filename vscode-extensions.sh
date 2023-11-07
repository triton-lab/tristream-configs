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

# Shell Script Command Completion
code --install-extension tetradresearch.vscode-h2o

# vscode-icons
code --install-extension vscode-icons-team.vscode-icons

# Trailing space
code --install-extension shardulm94.trailing-spaces

# Indent one space
code --install-extension usernamehw.indent-one-space

# Indent Rainbow
code --install-extension oderwat.indent-rainbow


# Copy extensions and configs to /etc/skel
sudo rm -rf /etc/skel/.vscode
sudo cp -rf ~/.vscode /etc/skel/.vscode

sudo rm -rf /etc/skel/.config/Code
sudo mkdir -p /etc/skel/.config/Code
sudo cp -rf ~/.config/Code/User /etc/skel/.config/Code

