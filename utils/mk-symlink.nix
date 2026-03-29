# mkSymlink — returns a store derivation that is a symlink to an
# out-of-store path. Use as a hjem files."<rel>".source value.
pkgs: target: pkgs.runCommandLocal (builtins.baseNameOf target) { } "ln -s ${target} $out"
