# ---
# Module: NixVim Plugins Switchboard
# Description: Imports all atomized plugin groups
# Scope: Home Manager
# ---

{ ... }: {
  imports = [
    ./ui.nix
    ./editor.nix
    ./navigation.nix
    ./lsp.nix
    ./formatting.nix
    ./git.nix
    ./completion.nix
    ./treesitter.nix
    ./copilot.nix
  ];
}
