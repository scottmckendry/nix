{
  inputs,
  pkgs,
  ...
}:

# Module for all of the the packages I personally maintain.
{
  home.packages = [
    inputs.cl-parse.packages.${pkgs.system}.default
    inputs.pat.packages.${pkgs.system}.default
    inputs.pokemon-go-colorscripts.packages.${pkgs.system}.default
    inputs.sunsetr.packages.${pkgs.system}.default
  ];
}
