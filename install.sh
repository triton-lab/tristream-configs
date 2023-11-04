#!/bin/bash

set -o errexit
set -o pipefail


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
readonly BASEDIR

# Update
sudo yum update -y
sudo yum upgrade -y


# Install essentials
sudo yum install -y git zsh fish wget curl htop vim emacs jq source-highlight ShellCheck cmake rclone ImageMagick


# Install fonts
sudo yum install -y \
  adobe-source-code-pro-fonts \
  google-noto-cjk-fonts \
  levien-inconsolata-fonts \
  roboto-fontface-fonts \
  open-sans-fonts \
  mozilla-fira-mono-fonts


# Cascadia Code fonts
FONT_PATH="/usr/share/fonts/CascadiaMono"
if [ ! -d "$FONT_PATH" ]; then
  wget -N https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip
  unzip -d CascadiaCode -o CascadiaCode-2111.01.zip
  sudo mkdir -p "$FONT_PATH"
  sudo cp -f CascadiaCode/ttf/CascadiaMono*.ttf "$FONT_PATH"/
  sudo fc-cache -f -
fi


# Firefox (Checks if Firefox is installed before installation.)
if ! command -v firefox &> /dev/null; then
  sudo amazon-linux-extras install firefox -y
fi


# vscode (Checks if Visual Studio Code is installed before installation.)
if ! command -v code &> /dev/null; then
  wget -N https://update.code.visualstudio.com/1.84.0/linux-rpm-x64/stable -O vscode.rpm
  sudo yum localinstall vscode.rpm -y
fi


# miniforge
wget -N https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
sudo mkdir -p /opt
CONDA_PREFIX=/opt/miniforge3
sudo rm -rf "$CONDA_PREFIX"
sudo bash Miniforge3-Linux-x86_64.sh -b -p "$CONDA_PREFIX"


# Make pip available via conda
sudo cp -f "$BASEDIR/conda.sh" /etc/profile.d/
source /etc/profile

# Set the environment variables
sudo cp -f "$BASEDIR/myenvvars.sh" /etc/profile.d/


# Basic python packages via mamba
sudo "$CONDA_PREFIX"/bin/mamba install -y -p "$CONDA_PREFIX" numpy ipython # pandas matplotlib seaborn scikit-learn scikit-image scipy jupyterlab


# pipx
export PIPX_HOME=/opt/share/pipx
export PIPX_BIN_DIR=/opt/bin
sudo mkdir -p "$PIPX_HOME"
sudo mkdir -p "$PIPX_BIN_DIR"
sudo "$CONDA_PREFIX"/bin/pip install --prefix "$CONDA_PREFIX" --force pipx
sudo "$CONDA_PREFIX"/bin/pipx install --force git+https://github.com/yamaton/condax


# condax
export CONDAX_BIN_DIR=/opt/bin
export CONDAX_PREFIX_DIR=/opt/share/condax/envs
export CONDAX_HIDE_EXITCODE=1
sudo mkdir -p "$CONDAX_BIN_DIR"
sudo mkdir -p "$CONDAX_PREFIX_DIR"
wget -N https://raw.githubusercontent.com/yamaton/test-binder/main/binder/_tools_condax.txt

CONDAX_LOG="condax_install_log.txt"
TOOLS=( "$(cat _tools_condax.txt)" )
for _tool in ${TOOLS[*]}; do
    echo "Installing ${_tool}" | tee -a "$CONDAX_LOG"
    # retry if nonzero exit status occurs
    sudo /opt/bin/condax install -c conda-forge -c bioconda --force "$_tool" 2>&1 | tee -a "$CONDAX_LOG"
    sudo "$CONDA_PREFIX"/bin/mamba clean --all --yes --force-pkgs-dirs
done

# Add blast to bandage package
sudo /opt/bin/condax inject -c bioconda -n bandage blast

# qiime2
wget -N https://data.qiime2.org/distro/core/qiime2-2023.7-py38-linux-conda.yml -O qiime2.yml
sudo /opt/bin/condax install -c conda-forge -c bioconda --force --file qiime2.yml q2cli 2>&1 | tee -a "$CONDAX_LOG"
rm -f qiime2.yml
sudo "$CONDA_PREFIX"/bin/mamba clean --all --yes --force-pkgs-dirs


# R and RStudio
sudo amazon-linux-extras install -y R3.4
sudo yum install -y R
wget -N https://download1.rstudio.org/electron/centos7/x86_64/rstudio-2023.09.1-494-x86_64.rpm -O rstudio.rpm
sudo yum localinstall rstudio.rpm -y


## Add application icons
# Bandage icon
wget -N https://raw.githubusercontent.com/rrwick/Bandage/main/images/application.ico
convert application.ico bandage.png
rm -f application.ico
sudo cp -f bandage-0.png /tmp/icons

# IGV icon
wget -N https://raw.githubusercontent.com/igvteam/igv/master/resources/IGV_64.ico
convert IGV_64.ico igv.png
sudo cp -f igv.png /tmp/icons
rm -f IGV_64.ico


## Add applications to the Gnome desktop database
sudo cp -f "$BASEDIR/bandage.desktop" /usr/share/applications/
sudo cp -f "$BASEDIR/igv.desktop" /usr/share/applications/
sudo update-desktop-database



## >>>>------------------------------------------------------------------------
## Setup dotfiles in /etc/skel

# .profile
sudo cp -f "$BASEDIR/profile.sh" /etc/skel/.profile


# .bash_logout
sudo cp -f "$BASEDIR/bash_logout" /etc/skel/.bash_logout


# zsh
sudo cp -f "$BASEDIR/zshrc" /etc/skel/.zshrc
zshdir=configs/zsh
mkdir -p "$zshdir"
pushd "$zshdir" || return
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions
    git clone --depth 1 https://github.com/zsh-git-prompt/zsh-git-prompt
    git clone --depth 1 https://github.com/yamaton/zsh-completions-bio
    git clone --depth 1 https://github.com/yamaton/zsh-completions-extra
popd || return
sudo mkdir -p /etc/skel/.config
sudo cp -rf configs/* /etc/skel/.config



# fish
fishcompdir=configs/fish/completions
mkdir -p "$fishcompdir"
pushd "$fishcompdir" || return
    git clone --depth 1 https://github.com/yamaton/fish-completions-bio
    git clone --depth 1 https://github.com/yamaton/fish-completions-extra
popd || return
sudo mkdir -p /etc/skel/.config/fish



# .condarc
#   Enable users to install conda environments
#   [NOTE] Add after system-wide conda/mamba installation
cat << 'EOF' | sudo tee /etc/skel/.condarc
channels:
  - bioconda
  - conda-forge

envs_dirs:
  - ~/.local/share/conda/envs
  - /opt/miniforge3/envs

pkgs_dirs:
  - ~/.local/share/conda/pkgs
  - /opt/miniforge3/pkgs
EOF


# .mambarc
# Run this after miniforge installation
echo "use_lockfiles: false" | sudo tee /etc/skel/.mambarc


# .less_termcap
wget -N https://raw.githubusercontent.com/yamaton/dotfiles/master/.less_termcap
sudo cp -f .less_termcap /etc/skel/

## <<<<------------------------------------------------------------------------
