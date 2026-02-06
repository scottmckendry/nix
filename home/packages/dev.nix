{ pkgs, ... }:
{
  home.packages = with pkgs; [
    air
    cargo
    gcc
    gnumake
    go-task
    just
    mermaid-cli
    neovim
    nil
    nixfmt
    nodejs
    odin
    presenterm
    python3
    rustc
    rustfmt
    sqlc
    sqlite
    typescript
    uv
    zig
  ];
}
