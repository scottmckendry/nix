# AGENTS.md

## Build, Lint, and Test

- **Build NixOS configs:**  
  `nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel`
- **Check configs (run tests):**  
  `nix flake check`
- **Show flake outputs:**  
  `nix flake show`
- **Switch system (as root):**  
  `sudo nixos-rebuild switch --flake .#<hostname>`
- **Format Nix files:**  
  Use `nixfmt` or `nixfmt-rfc-style` (see `modules/home/default.nix` for package).
- **Format Lua:**  
  `stylua` with `.stylua.toml` (120 cols, 4 spaces, prefer double quotes).
- **Format other files:**  
  Use conform.nvim (see `nvim/lua/plugins/conform.lua`) for:  
  - Lua: stylua  
  - Nix: nixfmt  
  - Go: goimports_reviser, gofmt  
  - Rust: rustfmt  
  - JS/TS/JSON/Markdown/YAML: prettier  
  - TOML: taplo  
  - Shell: shfmt

## Code Style Guidelines

- **Imports:**  
  Use relative imports for Nix modules and Lua files.
- **Formatting:**  
  Enforce formatting with stylua, nixfmt, and conform.nvim.
- **Types:**  
  Use explicit types in Nix where possible; Lua is dynamically typed.
- **Naming:**  
  Use lower_snake_case for Nix/Lua variables, PascalCase for modules.
- **Error Handling:**  
  Prefer explicit error messages and fail early in Nix expressions.
- **Comments:**  
  Use TODO/FIXME/NOTE for actionable comments (see todo-comments.nvim).
- **Git:**  
  Do not commit secrets; only files tracked by git are included in builds.
- **General:**  
  Follow NixOS and Neovim community best practices.
