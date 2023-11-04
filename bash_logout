#!/bin/bash

# Limit to as2-streaming-user
if [ ! "$HOME" = "/home/as2-streaming-user" ]; then
  echo "Home: $HOME"
  return
fi

source_dir="$HOME"
target_dir="$HOME/MyFiles/HomeFolder/configs"

# Ensure source directory exists
if [ ! -d "$source_dir" ]; then
  echo "Source directory does not exist: $source_dir" >&2
  return
fi

# Ensure target directory exists
if [ ! -d "$target_dir" ]; then
  echo "Target directory does not exist: $target_dir" >&2
  return
else
  owner=$(stat -c '%U' "$target_dir")
  if [ "$owner" = "root" ]; then
    echo "The owner of the target directory is root: $target_dir"
    return
  fi
fi

# Sync dotfiles and directories, excluding symbolic links
rsync -av --no-links --include='.*' --exclude='*' "$source_dir"/ "$target_dir"
