{
  pkgs,
  config,
  hostname,
  ...
}:

{
  home =
    if hostname == "helios" then
      {
        packages = with pkgs; [
          wsl-open
          xdg-utils
        ];

        # associate WSL filetypes for xdg-open compatibility
        activation = {
          wslopen = config.lib.dag.entryBefore [ "writeBoundary" ] ''
            ${pkgs.wsl-open}/bin/wsl-open -w || true
          '';
        };
      }
    else
      {
      };
}
