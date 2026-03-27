{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.go;
in
{
  options.custom.services.go = {
    enable = lib.mkEnableOption "Go development environment";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      air
      go
      gopls
      gotestsum
    ];

    environment.sessionVariables = {
      GOPATH = "$HOME/go";
      GOBIN = "$HOME/go/bin";
    };
  };
}
