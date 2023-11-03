#!/bin/bash

# Get the manifest used by `AppStreamImageAssistant add-application`
# Usage: get-manifest.sh <program_name>

set -o errexit
set -o nounset
set -o pipefail

# Check if the program name is provided as an argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 <program_name>"
  exit 1
fi

program_name=$1
pid=$(pgrep -o "$program_name")

if [ -z "$pid" ]; then
  echo "Program '$program_name' is not running."
  exit 2
fi

lsof -p "$(pstree -p "$pid" | grep -o '([0-9]\+)' | grep -o '[0-9]\+' | tr '\012' ,)" | grep REG | sed -n '1!p' | awk '{print $9}'| awk 'NF'
