{ pkgs, ... }:
let
  opencode = pkgs.stdenv.mkDerivation rec {
    pname = "opencode";
    version = "0.1.194";

    src = pkgs.fetchzip {
      url = "https://github.com/sst/opencode/releases/download/v${version}/opencode-linux-x64.zip";
      hash = "sha256-Z0rMPmm8prlpdJsy5iqBO5BF5VnJ9oUX4+zbT7D1XT8=";
    };

    phases = [
      "installPhase"
      "patchPhase"
    ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src/opencode $out/bin/opencode
      chmod +x $out/bin/opencode
    '';
  };
in
{
  home.packages = [ opencode ];
  home.file.".config/opencode/config.json".text = ''
    {
      "$schema": "https://opencode.ai/config.json",
      "theme": "system"
    }
  '';
}
