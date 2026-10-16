{ lib, ... }:
{
  # NOTE: see config.nix for symlinked config files.
  den.aspects.librewolf = {
    nixos =
      { pkgs, ... }:
      let
        # Extension IDs are the gecko IDs from each add-on's
        # browser_specific_settings.gecko.id. `slug` is the addons.mozilla.org slug.
        extensions = {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            slug = "bitwarden-password-manager";
            private = true; # available in private windows
          };
          "{3c078156-979c-498b-8990-85f7987dd929}" = {
            slug = "sidebery";
          };
          "ATBC@EasonWong" = {
            slug = "adaptive-tab-bar-colour";
          };
        };

        extensionSettings = builtins.mapAttrs (
          _: ext:
          {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${ext.slug}/latest.xpi";
          }
          // lib.optionalAttrs (ext.private or false) { private_browsing = true; }
        ) extensions;
      in
      {
        environment.systemPackages = [
          (pkgs.librewolf.override {
            extraPolicies.ExtensionSettings = extensionSettings;
          })
        ];
      };
  };
}
