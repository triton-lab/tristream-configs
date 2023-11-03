# /etc/skel/.profile

# Limit to as2-streaming-user
if [ "$HOME" != "/home/as2-streaming-user" ]; then
  echo "Home: $HOME"
  return
fi


# Create conda environment directories
mkdir -p "$HOME/.local/share/conda/envs"
mkdir -p "$HOME/.local/share/conda/pkgs"


# Load dotfiles from the persistent storage
# Define the source and target directories
source_dir="$HOME/MyFiles/HomeFolder/configs"
target_dir="$HOME"

# Ensure the source directory exists
if [ ! -d "$source_dir" ]; then
  echo "Source directory does not exist: $source_dir"
  return
fi

# Change to the source directory
cd "$source_dir" || return

# Loop over all dot files and directories in the source directory
for item in .*; do
  # Skip '.' and '..' and *.bak
  if [ "$item" == "." ] || [ "$item" == ".." ] || [[ "$item" =~ \.bak$ ]]; then
    continue
  fi

  # Define the source and target paths
  source_path="$source_dir/$item"
  target_path="$target_dir/$item"

  # If the target path already exists
  if [ -f "$target_path" ] || [ -d "$target_path" ]; then
    # Rename the existing file/directory with a .bak suffix
    mv "$target_path" "${target_path}.bak"
  fi

  # sync with the persistent user data storage
  # [NOTE] prefer copy over symbolic ink because the persitent storage is not always available
  rsync -av --no-links --include='.*' --exclude='*' "$source_path" "$target_path"

done

echo "Symbolic links created successfully!"

