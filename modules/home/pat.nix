{
  inputs,
  pkgs,
  ...
}:

{
  home.packages = [
    inputs.pat.packages.${pkgs.system}.default
  ];
}
