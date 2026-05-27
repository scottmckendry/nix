{ inputs, ... }:
{
  den.aspects.core = {
    nixos =
      { config, ... }:
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];

        sops = {
          defaultSopsFile = ../../secrets/secrets.sops.yaml;
          age.keyFile = "/var/lib/sops-nix/key.txt";
          secrets.u2f_keys_txt = {
            owner = config.users.users.scott.name;
            path = "/home/scott/.config/Yubico/u2f_keys";
          };
          secrets.azure_devops_pat_txt = {
            owner = config.users.users.scott.name;
            path = "/run/secrets/azure_devops_pat";
          };
          secrets.azure_devops_skill_md = {
            owner = config.users.users.scott.name;
            path = "/run/secrets/opencode/skills/azure-devops-boards/SKILL.md";
          };
          secrets.obsidian_livesync_settings = {
            owner = config.users.users.scott.name;
            path = "/home/scott/Documents/obsidian/.livesync/settings.json";
          };
        };
      };
  };
}
