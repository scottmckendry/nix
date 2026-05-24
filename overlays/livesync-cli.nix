final: prev: {
  obsidian-livesync-cli = prev.buildNpmPackage (finalAttrs: {
    pname = "obsidian-livesync-cli";
    version = "0.25.69";

    src = prev.fetchgit {
      url = "https://github.com/vrtmrz/obsidian-livesync";
      rev = "0.25.69";
      hash = "sha256-LiE/G3KJ2D1s94RdfFsGqPnmV4womlIjTmNafvKB8i8=";
      fetchSubmodules = true;
    };

    npmDepsHash = "sha256-62Eh+XoCogx/4Bk5ka58uXJwFRzAfvl2SquH62T6Auc=";

    nativeBuildInputs = [ prev.makeWrapper ];

    # npm install runs at root (deps declared in root package.json)
    # Build happens in src/apps/cli subdir via vite
    buildPhase = ''
      runHook preBuild
      npm run build --prefix src/apps/cli
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # Node_modules + built CLI bundles.
      # Can't prune devDeps here — packages like pouchdb-adapter-http
      # are declared as devDeps in the root package.json but are
      # needed at runtime by the bundled CLI via require().
      mkdir -p $out/lib/node_modules/${finalAttrs.pname}
      mkdir -p $out/bin

      cp -r node_modules $out/lib/node_modules/${finalAttrs.pname}/
      cp -r src/apps/cli/dist $out/lib/node_modules/${finalAttrs.pname}/

      makeWrapper ${prev.nodejs}/bin/node $out/bin/livesync-cli \
        --add-flags $out/lib/node_modules/${finalAttrs.pname}/dist/index.cjs

      runHook postInstall
    '';

    meta = {
      description = "Headless CLI for Self-hosted LiveSync";
      longDescription = ''
        Command-line version of Self-hosted LiveSync plugin for syncing Obsidian vaults
        without running Obsidian. Supports CouchDB sync, mirror, daemon mode with
        chokidar file watching and _changes feed for near-real-time sync.
      '';
      homepage = "https://github.com/vrtmrz/obsidian-livesync";
      license = prev.lib.licenses.mit;
      platforms = prev.lib.platforms.linux;
      mainProgram = "livesync-cli";
    };
  });
}
