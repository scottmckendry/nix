{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (buildGoModule {
      pname = "templui";
      version = "0.80.2";
      src = fetchFromGitHub {
        owner = "axzilla";
        repo = "templui";
        rev = "v0.80.2";
        sha256 = "sha256-fV8rojMikA6cKsz5vTQS84/Iv175LsFHLQhPPWcGyEw=";
      };
      vendorHash = "sha256-k8zxMgiDSQ3DpWpuKCePnWbi+dI99CWjbk8mU4JPoz4=";
      subPackages = [ "cmd/templui" ];
      proxyVendor = true;
    })
  ];
}
