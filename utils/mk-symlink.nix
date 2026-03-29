# mkSymlink — returns a store derivation that is a symlink to an
# out-of-store path. Use as a hjem files."<rel>".source value.
#
# Usage:
#   let mkSym = mkSymlink pkgs; in
#   files = {
#     ".config/niri".source   = mkSym "/home/scott/git/nix/home/.config/niri";
#     ".config/waybar".source = mkSym "/home/scott/git/nix/home/.config/waybar";
#   };
pkgs: target: pkgs.runCommandLocal (builtins.baseNameOf target) { } "ln -s ${target} $out"
