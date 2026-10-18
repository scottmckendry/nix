# TODO: remove this when upstream PR merges:
# https://github.com/NixOS/nixpkgs/pull/575463
final: prev:
let
  version = "2026.239.6882";

  sources = {
    x86_64-linux = {
      url = "https://binaries.twingate.com/client/linux/DEB/x86_64/${version}/twingate-amd64.deb";
      hash = "sha256-BLPXDW21LeidOAbwuTd+LrZo/hF3Zp6F56F015CXPm4=";
    };
    aarch64-linux = {
      url = "https://binaries.twingate.com/client/linux/DEB/aarch64/${version}/twingate-arm64.deb";
      hash = "sha256-EdCxpsTw1H2MS6tk++xKs66m/fXzP2wNGcv6PP/9G8I=";
    };
  };
in
{
  twingate = prev.twingate.overrideAttrs (old: {
    inherit version;
    src = prev.fetchurl sources.${prev.stdenv.hostPlatform.system};

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv etc $out/
      mv usr/bin $out/bin
      mv usr/sbin/* $out/bin
      mv usr/lib $out/lib
      mv usr/share $out/share

      # 2026.188 renamed the CLI to `twingate-classic`
      ln -s twingate-classic $out/bin/twingate

      runHook postInstall
    '';
  });
}
