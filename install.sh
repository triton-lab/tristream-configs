#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
readonly BASEDIR

# Update
sudo yum update -y
sudo yum upgrade -y


# Install essentials
sudo yum install -y git wget curl htop vim emacs jq source-highlight ShellCheck cmake rclone ImageMagick


# Install fonts
sudo yum install \
  adobe-source-code-pro-fonts \
  google-noto-cjk-fonts \
  levien-inconsolata-fonts \
  roboto-fontface-fonts \
  open-sans-fonts \
  mozilla-fira-mono-fonts


# Cascadia Code fonts
wget https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip
unzip CascadiaCode-2111.01.zip -d CascadiaCode
sudo mkdir /usr/share/fonts/CascadiaMono
sudo cp CascadiaCode/ttf/CascadiaMono*.ttf /usr/share/fonts/CascadiaMono/
sudo fc-cache -f -


# Firefox
sudo amazon-linux-extras install firefox -y


# vscode
wget https://update.code.visualstudio.com/1.84.0/linux-rpm-x64/stable -O vscode.rpm
sudo yum localinstall vscode.rpm -y


# miniforge
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
sudo mkdir -p /opt
sudo bash Miniforge3-Linux-x86_64.sh -b -p /opt/miniforge3


# Make pip available via conda
sudo mv "$BASEDIR/conda.sh" /etc/profile.d/
source /etc/profile

# Basic python packages via mamba
mamba install ipython numpy pandas matplotlib seaborn scikit-learn scikit-image scipy jupyterlab -y


# pipx
export PIPX_HOME=/opt/share/pipx
export PIPX_BIN_DIR=/opt/bin
mkdir -p "$PIPX_HOME"
pip install pipx
pipx install git+https://github.com/yamaton/condax


# condax
export CONDAX_BIN_DIR=/opt/bin
export CONDAX_PREFIX_DIR=/opt/share/condax/envs
export CONDAX_HIDE_EXITCODE=1
mkdir -p "$CONDAX_BIN_DIR"
mkdir -p "$CONDAX_PREFIX_DIR"
wget https://raw.githubusercontent.com/yamaton/test-binder/main/binder/_tools_condax.txt

CONDAX_LOG="condax_install_log.txt"
TOOLS=( "$(cat _tools_condax.txt)" )
for _tool in ${TOOLS[*]}; do
    echo "Installing ${_tool}" | tee -a "$CONDAX_LOG"
    # retry if nonzero exit status occurs
    if [[ ! ($(condax install -c conda-forge -c bioconda --force "$_tool" 2>&1 | tee -a "$CONDAX_LOG")) ]]; then
        echo "condax retrying... $_tool" | tee -a "$CONDAX_LOG"
        condax remove "$_tool" | tee -a "$CONDAX_LOG"
        condax install -c conda-forge -c bioconda --force "$_tool" 2>&1 | tee -a "$CONDAX_LOG"
    fi
    mamba clean --all --yes --force-pkgs-dirs
done

# Add blast to bandage package
condax inject -c bioconda -n bandage blast

# qiime2
wget https://data.qiime2.org/distro/core/qiime2-2023.7-py38-linux-conda.yml -O qiime2.yml
condax install -c conda-forge -c bioconda --force --file qiime2.yml q2cli 2>&1 | tee -a "$CONDAX_LOG"
rm -f qiime2.yml
mamba clean --all --yes --force-pkgs-dirs


# R and RStudio
sudo amazon-linux-extras install R3.4
sudo yum install -y R
wget https://download1.rstudio.org/electron/centos7/x86_64/rstudio-2023.09.1-494-x86_64.rpm -O rstudio.rpm
sudo yum localinstall rstudio.rpm -y


## Add application icons
# Bandage icon
wget https://raw.githubusercontent.com/rrwick/Bandage/main/images/application.ico
convert application.ico bandage.png
rm -f application.ico
sudo cp bandage-0.png /tmp/icons

# IGV icon
wget https://raw.githubusercontent.com/igvteam/igv/master/resources/IGV_64.ico
convert IGV_64.ico igv.png
sudo mv igv.png /tmp/icons
rm -f IGV_64.ico


## Add applications to the Gnome desktop database
sudo cp "$BASEDIR/bandage.desktop" /usr/share/applications/
sudo cp "$BASEDIR/igv.desktop" /usr/share/applications/
sudo update-desktop-database



## >>>>------------------------------------------------------------------------
## Setup dotfiles in /etc/skel

# .profile
sudo cp "$BASEDIR/profile.sh" /etc/skel/.profile


# .bash_logout
sudo cp "$BASEDIR/bash_logout" /etc/skel/.bash_logout


# zsh
sudo cp "$BASEDIR/zshrc" /etc/skel/.zshrc
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
  - /opt/miniforge/envs

pkgs_dirs:
  - ~/.local/share/conda/pkgs
  - /opt/miniforge/pkgs
EOF


# .mambarc
# Run this after miniforge installation
echo "use_lockfiles: false" | sudo tee /etc/skel/.mambarc


# .less_termcap
wget https://raw.githubusercontent.com/yamaton/dotfiles/master/.less_termcap
sudo mv .less_termcap /etc/skel/

## <<<<------------------------------------------------------------------------
