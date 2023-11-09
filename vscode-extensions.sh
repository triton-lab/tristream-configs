#!/bin/bash

set -o errexit
set -o pipefail

# Python
code --install-extension ms-python.python
code --install-extension ms-python.pylint
code --install-extension ms-python.mypy-type-checker
code --install-extension ms-python.black-formatter

# IntelliCode
code --install-extension visualstudioexptteam.vscodeintellicode

# Path Intellisense
code --install-extension christian-kohler.path-intellisense

# Docker
code --install-extension ms-azuretools.vscode-docker

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

echo "Extensions installed successfully!"
echo "=================== IMPORTANT ==================="
echo "Load bioinformatics CLI specs with vscode-hwo."
echo "=================== IMPORTANT ==================="


# Copy extensions and configs to /etc/skel
sudo rm -rf /etc/skel/.vscode
sudo cp -rf ~/.vscode /etc/skel/.vscode

sudo rm -rf /etc/skel/.config/Code
sudo mkdir -p /etc/skel/.config/Code
sudo cp -rf ~/.config/Code/User /etc/skel/.config/Code

