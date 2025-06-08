{ pkgs, ... }:
{
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
}
