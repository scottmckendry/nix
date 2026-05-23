# Apply NixOS config (switch)
rebuild:
    ./scripts/rebuild.sh switch

# Apply NixOS config on next boot
boot:
    ./scripts/rebuild.sh boot

# Update flake inputs
update:
    nix flake update

# Decrypt all secrets to tmpfs workspace
decrypt:
    ./scripts/sops.sh decrypt

# Encrypt all secrets from tmpfs workspace back to repo
encrypt:
    ./scripts/sops.sh encrypt

# Clear tmpfs workspace and remove symlinks from secrets/
clean:
    ./scripts/sops.sh clean
