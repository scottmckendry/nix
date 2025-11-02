{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.generic
  ];
}
