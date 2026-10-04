# Emit a shell-safe `name=... url=...` assignment for the vendor zip that
# nixpkgs' displaylink package expects. We overlay requireFile so the
# requirement message itself becomes readable instead of failing the build.
let
  flake = builtins.getFlake (toString ./..);
  pkgs = import flake.inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        requireFile = args: args;
      })
    ];
  };
  msg = pkgs.displaylink.src.message;
  matches = builtins.match ".*(https://www\\.synaptics\\.com/sites/default/files/exe_files/[^ \n]+).*" msg;
in
"name=${pkgs.lib.escapeShellArg pkgs.displaylink.src.name} url=${pkgs.lib.escapeShellArg (builtins.head matches)}"
