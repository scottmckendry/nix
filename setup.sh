#!/usr/bin/env bash

# Change to the directory of this script
cd "$(dirname "$0")"

declare -A mappings=(
    [$HOME/git/nix/nvim]=$HOME/.config/nvim
    [$HOME/git/nix/hypr]=$HOME/.config/hypr
    [$HOME/git/nix/waybar]=$HOME/.config/waybar
    [$HOME/git/nix/wofi]=$HOME/.config/wofi
)

echo "Removing existing files/directories..."
for key in "${!mappings[@]}"; do
    rm -rf ${mappings[$key]}
done

echo "Creating symbolic links..."
for key in "${!mappings[@]}"; do
    ln -sf $key ${mappings[$key]}
done

echo "Creating symbolic link to NixOS configuration..."
sudo rm -rf /etc/nixos/configuration.nix
sudo ln -sf $HOME/git/nix/configuration.nix /etc/nixos/configuration.nix

echo "Done!"
