{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (buildGoModule {
      pname = "templui";
      version = "0.81.1";
      src = fetchFromGitHub {
        owner = "axzilla";
        repo = "templui";
        rev = "v0.81.1";
        sha256 = "sha256-iDz+Dwz9g+gGMt+AOr5tkhej9l8S0sMIuHcFe1Uqi4c=";
      };
      vendorHash = "sha256-6u+sOB970xiZjxDdP75GE+oTZ5vQxBS3RoFldzokoQ8=";
      subPackages = [ "cmd/templui" ];
      proxyVendor = true;
    })
  ];
}
