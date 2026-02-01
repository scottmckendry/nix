{ pkgs, inputs, ... }:
let
  cl-parse = inputs.cl-parse.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = with pkgs; [
    ansible
    cl-parse
    fluxcd
    k9s
    kubectl
    kubectl-cnpg
    talosctl
    terraform
  ];
}
