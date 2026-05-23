# Secrets

Managed with [sops](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age) via [sops-nix](https://github.com/Mic92/sops-nix).

Encrypted secrets live in `secrets.sops.yaml`. Keys use suffix conventions: `_txt` → `.txt`, `_md` → `.md`, `_yaml` → `.yaml`.

Decrypted files are written to `$XDG_RUNTIME_DIR/sops-workspace/nix/` (tmpfs, cleared on reboot) and symlinked into `secrets/`.

```bash
just decrypt   # decrypt → tmpfs, symlink into secrets/
just encrypt   # read symlinks, re-encrypt → secrets/secrets.sops.yaml
```

Age key must be stored in GNOME keyring:

```bash
secret-tool store --label="age secret key" app sops type age-key
```

## Adding a new host's U2F key

1. On the new host, generate a key handle:
   ```bash
   pamu2fcfg -u scott -n
   ```
2. `just decrypt`
3. Edit `$XDG_RUNTIME_DIR/sops-workspace/nix/u2f_keys_txt.txt` — append the new handle with `:` separator
4. `just encrypt`
5. `just rebuild` on affected hosts
