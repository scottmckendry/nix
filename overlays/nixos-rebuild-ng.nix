# Keep test_make_tmpdir enabled on unsandboxed builders with shared /tmp.
# TODO: Remove this overlay once the fix reaches the pinned nixpkgs:
# https://github.com/NixOS/nixpkgs/pull/588801
_final: prev: {
  nixos-rebuild-ng = prev.nixos-rebuild-ng.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (builtins.toFile "nixos-rebuild-ng-test-tmpdir.patch" (
        builtins.concatStringsSep "\n" [
          "diff --git a/tests/test_tmpdir.py b/tests/test_tmpdir.py"
          "index 51c2956bb5c146..01b2ed673fee9a 100644"
          "--- a/tests/test_tmpdir.py"
          "+++ b/tests/test_tmpdir.py"
          "@@ -31,20 +31,29 @@ def assert_tmpdir(tmp: Path) -> None:"
          " "
          "     assert_tmpdir(tmp)"
          " "
          "-    # Test with a short system temp dir. We should use it unmodified."
          "-    short_tempdir = \"/tmp/not-too-long\""
          "-    with tempfile_tempdir(short_tempdir):"
          "-        tmpdir = make_tmpdir()"
          "-        tmp = Path(tmpdir.name)"
          "-"
          "-        assert tmp.parent == Path(short_tempdir)"
          "-        assert_tmpdir(tmp)"
          "-"
          "-    # Test with a long system temp dir. We should ignore"
          "-    # it and fall back to something short enough for OpenSSH to"
          "-    # create sockets in."
          "-    with tempfile_tempdir(\"/tmp/long\" + (\"g\" * MAX_TMPDIR_LENGTH)):"
          "-        tmpdir = make_tmpdir()"
          "-        tmp = Path(tmpdir.name)"
          "-"
          "-        assert_tmpdir(tmp)"
          "+    # Both system temp dirs below are created fresh by this test and removed"
          "+    # when it ends. A fixed path such as /tmp/not-too-long is shared by every"
          "+    # build on the machine: where builds run unsandboxed under several build"
          "+    # users (e.g. Darwin with `sandbox = false`), it stays owned by whichever"
          "+    # user created it first, and every other user then fails to create a"
          "+    # temporary directory in it. /tmp is the parent on purpose, because the"
          "+    # default temp dir may itself be too long."
          "+    with tempfile.TemporaryDirectory(prefix=\"nr-\", dir=\"/tmp\") as owned:"
          "+        # Test with a short system temp dir. We should use it unmodified."
          "+        short_tempdir = owned"
          "+        with tempfile_tempdir(short_tempdir):"
          "+            tmpdir = make_tmpdir()"
          "+            tmp = Path(tmpdir.name)"
          "+"
          "+            assert tmp.parent == Path(short_tempdir)"
          "+            assert_tmpdir(tmp)"
          "+"
          "+        # Test with a long system temp dir. We should ignore"
          "+        # it and fall back to something short enough for OpenSSH to"
          "+        # create sockets in."
          "+        long_tempdir = str(Path(owned) / (\"long\" + (\"g\" * MAX_TMPDIR_LENGTH)))"
          "+        with tempfile_tempdir(long_tempdir):"
          "+            tmpdir = make_tmpdir()"
          "+            tmp = Path(tmpdir.name)"
          "+"
          "+            assert_tmpdir(tmp)"
          ""
        ]
      ))
    ];
  });
}
