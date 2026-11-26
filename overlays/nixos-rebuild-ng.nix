# nixos-rebuild-ng's test suite writes to fixed shared paths (/tmp/not-too-long
# and /tmp/longggg...) and never cleans up after itself. On an unsandboxed
# builder — the flakemill container runs with `sandbox = false` — /tmp is shared
# by every nixbld user, so the directory ends up owned by whichever build user
# created it first, and every later build user gets PermissionError inside it.
# One flake-input bump is enough to hand the build to a different uid and turn
# the whole host build red.
#
# Deselect the one test rather than the whole suite: doCheck does nothing here
# (the package already has doCheck = false; pytest-check-hook appends
# pytestCheckPhase to preDistPhases, and distPhase ignores doCheck), and
# dontUsePytestCheck throws away 84 tests that pass fine.
#
# TODO: drop this once nixpkgs PR #588801 ("nixos-rebuild-ng: use a per-run temp
# root in test_tmpdir") lands and reaches the pinned nixpkgs. Upstream tracking
# issue https://github.com/NixOS/nixpkgs/issues/539644 is closed, but #540017
# was merged without fixing this — it only changed how the fixture sets TMPDIR.
_final: prev:
{
  nixos-rebuild-ng = prev.nixos-rebuild-ng.overrideAttrs (_: {
    disabledTests = [ "test_make_tmpdir" ];
  });
}
