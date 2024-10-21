{ pkgs, inputs, ... }:

# https://github.com/oxalica/rust-overlay
let
  nightlyVersion = "2024-10-20";
  rust = pkgs.rust-bin.nightly.${nightlyVersion}.default.override {
    extensions = [
      "rust-src"
      "rustfmt"
      "clippy"
    ];
  };
in
{
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];
  environment.systemPackages = [ rust ];
}
