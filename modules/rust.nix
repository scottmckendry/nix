{ pkgs, inputs, ... }:

# https://github.com/oxalica/rust-overlay
let
  nightlyVersion = "2024-10-01";
in
{
  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
  ];
  environment.systemPackages = [
    pkgs.rust-bin.nightly.${nightlyVersion}.default
  ];
}
