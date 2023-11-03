#!/bin/bash

## ==============================================
## Adding applications to the AppStream database
##
## Create manifest files
##    1. Run the program
##    2. Create manifest file with the following command:
##        ./get-manifest.sh <program_name> | sudo tee /tmp/<program_name>-manifest.txt
## ==============================================


## >>>>------------------------------------------------------------------------
## List applications
## AppStreamImageAssistant list-applications
##
## Remove an application
## AppStreamImageAssistant remove-application --name <application_name>
## <<<<------------------------------------------------------------------------

set -o errexit
set -o nounset
set -o pipefail


# --- firefox ---
AppStreamImageAssistant add-application \
    --name "Firefox" \
    --absolute-app-path "/usr/bin/firefox" \
    --display-name "Firefox" \
    --absolute-icon-path "/usr/share/icons/hicolor/256x256/apps/firefox.png" \
    --absolute-manifest-path "/tmp/firefox-manifest.txt"


# --- vscode ---
wget https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Visual_Studio_Code_1.18_icon.svg/512px-Visual_Studio_Code_1.18_icon.svg.png -O vscode.png
sudo mv vscode.png /tmp/icons

AppStreamImageAssistant add-application \
    --name "vscode" \
    --absolute-app-path "/usr/bin/code" \
    --display-name "Visual Studio Code" \
    --absolute-icon-path "/tmp/icons/vscode.png" \
    --absolute-manifest-path "/tmp/vscode-manifest.txt"


# --- nautilus ---
AppStreamImageAssistant add-application \
    --name "Nautilus" \
    --absolute-app-path "/usr/bin/nautilus" \
    --display-name "Files" \
    --absolute-icon-path "/usr/share/icons/gnome/256x256/apps/system-file-manager.png" \
    --absolute-manifest-path "/tmp/nautilus-manifest.txt"


# --- gnome-terminal ---
AppStreamImageAssistant add-application \
    --name "Terminal" \
    --absolute-app-path "/usr/bin/gnome-terminal" \
    --display-name "Terminal" \
    --absolute-icon-path "/usr/share/icons/gnome/256x256/apps/utilities-terminal.png" \
    --absolute-manifest-path "/tmp/terminal-manifest.txt"


# --- gedit ---
AppStreamImageAssistant add-application \
    --name "gedit" \
    --absolute-app-path "/usr/bin/gedit" \
    --display-name "Text Editor" \
    --absolute-icon-path "/usr/share/icons/hicolor/256x256/apps/org.gnome.gedit.png" \
    --absolute-manifest-path "/tmp/gedit-manifest.txt"


# --- Bandage ---
AppStreamImageAssistant add-application \
    --name "Bandage" \
    --absolute-app-path "/opt/bin/Bandage" \
    --display-name "Bandage" \
    --absolute-icon-path "/tmp/icons/bandage-0.png" \
    --absolute-manifest-path "/tmp/Bandage-manifest.txt"


# --- IGV ---
AppStreamImageAssistant add-application \
    --name "IGV" \
    --absolute-app-path "/opt/bin/igv" \
    --display-name "IGV" \
    --absolute-icon-path "/tmp/icons/igv.png" \
    --absolute-manifest-path "/tmp/igv-manifest.txt"
