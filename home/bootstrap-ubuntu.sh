#!/usr/bin/env bash
set -euo pipefail

# Bootstrap script for setting up Nix and Home Manager on Ubuntu Server
# Usage: ./bootstrap-ubuntu.sh [git-repo-url]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIX_REPO_URL="${1:-https://github.com/scottmckendry/nix.git}"
NIX_CONFIG_DIR="${HOME}/git/nix"

echo "==> Starting Nix and Home Manager setup..."

# Install dependencies
echo "==> Installing dependencies..."
if ! command -v curl &>/dev/null || ! command -v git &>/dev/null || ! command -v xz &>/dev/null; then
    sudo apt-get update
    sudo apt-get install -y curl git xz-utils kitty-terminfo
fi

# Check if Nix is already installed
if [ ! -d /nix/var/nix/profiles/default ]; then
    echo "==> Installing Nix (multi-user)..."
    curl -L https://nixos.org/nix/install -o /tmp/install-nix.sh
    chmod +x /tmp/install-nix.sh
    sudo sh /tmp/install-nix.sh --daemon --yes
    rm -f /tmp/install-nix.sh

    echo "==> Nix installed successfully"
else
    echo "==> Nix is already installed, skipping installation"
fi

# Source Nix profile for current session
if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Add Nix to bashrc if not already present
if ! grep -q "nix-daemon.sh" "${HOME}/.bashrc"; then
    echo "==> Adding Nix to ~/.bashrc..."
    echo '' >>"${HOME}/.bashrc"
    echo '# Nix daemon' >>"${HOME}/.bashrc"
    echo 'if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then' >>"${HOME}/.bashrc"
    echo '    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' >>"${HOME}/.bashrc"
    echo 'fi' >>"${HOME}/.bashrc"
fi

# Enable experimental features
echo "==> Enabling experimental Nix features..."
if ! sudo grep -q "experimental-features = nix-command flakes" /etc/nix/nix.conf 2>/dev/null; then
    sudo mkdir -p /etc/nix
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf >/dev/null

    echo "==> Restarting nix-daemon..."
    sudo systemctl restart nix-daemon
    sudo systemctl enable nix-daemon

    # Wait for daemon to be ready
    sleep 5
fi

# Clone or update nix configuration repository
if [ ! -d "${NIX_CONFIG_DIR}" ]; then
    echo "==> Cloning nix configuration repository..."
    mkdir -p "$(dirname "${NIX_CONFIG_DIR}")"
    git clone "${NIX_REPO_URL}" "${NIX_CONFIG_DIR}"
else
    echo "==> Updating nix configuration repository..."
    git -C "${NIX_CONFIG_DIR}" pull
fi

# Build and activate home-manager configuration
echo "==> Building and activating Home Manager configuration..."
nix run home-manager/master -- switch --flake "${NIX_CONFIG_DIR}#default" -b backup

echo ""
echo "==> Setup complete!"
echo "==> Please log out and back in, or run: source ~/.bashrc"
