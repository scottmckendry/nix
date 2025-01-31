{ pkgs, inputs, ... }:

# https://github.com/oxalica/rust-overlay
let
  nightlyVersion = "2025-01-25";
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
