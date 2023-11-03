#!/bin/bash

# Limit to as2-streaming-user
if [ ! "$HOME" = "/home/as2-streaming-user" ]; then
  echo "Home: $HOME"
  return 0
fi

source_dir="$HOME"
target_dir="$HOME/MyFiles/HomeFolder/configs"

# Ensure source directory exists
if [ ! -d "$source_dir" ]; then
  echo "Source directory does not exist: $source_dir" >&2
  return 1
fi

# Ensure target directory exists
if [ ! -d "$target_dir" ]; then
  echo "Target directory does not exist: $target_dir" >&2
  return 1
else
  owner=$(stat -c '%U' "$target_dir")
  if [ "$owner" = "root" ]; then
    echo "The owner of the target directory is root: $target_dir"
    return 1
  fi
fi

# Delete dot files in target directory if their corresponding symbolic links or files are absent in source directory
find "$target_dir" -maxdepth 1 -type f -name '.*' | while IFS= read -r file; do
  base_name=$(basename "$file")
  if [ ! -e "$source_dir/$base_name" ]; then
    echo "Deleting: $file"
    rm -- "$file"
  fi
done

# Sync dotfiles and directories, excluding symbolic links
rsync -av --no-links --include='.*' --exclude='*' "$source_dir/" "$target_dir"
