{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    wsl-open
    xdg-utils
  ];

  # Associate WSL filetypes for xdg-open compatibility
  home.activation = {
    wslopen = config.lib.dag.entryBefore [ "writeBoundary" ] ''
      ${pkgs.wsl-open}/bin/wsl-open -w || true
    '';
  };
}
