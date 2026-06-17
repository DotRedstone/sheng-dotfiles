# ---
# Module: NixVim Switchboard
# Description: Unified entry point for atomized Neovim configuration
# Scope: Home Manager
# ---

{ ... }: {
  imports = [
    ./packages.nix
    ./core.nix
    ./options.nix
    ./diagnostics.nix
    ./keymaps.nix
    ./autocmds.nix
    ./colorscheme.nix
    ./plugins
  ];
}
