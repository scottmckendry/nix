# Secrets

Managed with [sops](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age).

Encrypted files: `*.secret.sops.yaml`  
Decrypted workspace: `$XDG_RUNTIME_DIR/sops-workspace/nix/` (tmpfs, cleared on reboot)

## Workflow

```bash
# Decrypt all secrets into workspace (required before editing)
just decrypt

# Edit decrypted file
$EDITOR $XDG_RUNTIME_DIR/sops-workspace/nix/secrets/u2f.secret.yaml

# Re-encrypt back to repo
just encrypt
```

## Adding a new host's U2F key

1. On the new host, generate a key handle:
   ```bash
   pamu2fcfg -u scott -n
   ```
2. Decrypt secrets: `just decrypt`
3. Edit `u2f.secret.yaml` — append the new handle to the existing `u2f_keys` line with `:` separator:
   ```yaml
   u2f_keys: scott:<handle1>:<handle2>
   ```
4. Re-encrypt: `just encrypt`
5. Rebuild on affected hosts: `just rebuild`

## Age key

Must be present at `/var/lib/sops-nix/key.txt` (used by sops-nix on activation), owned `root:root` with mode `0600`.

For manual encrypt/decrypt operations (`just decrypt`/`just encrypt`), the key must also be stored in GNOME keyring:

```bash
secret-tool store --label="age secret key" app sops type age-key
```
