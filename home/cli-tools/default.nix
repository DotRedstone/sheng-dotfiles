# ---
# Module: CLI Tools Switchboard
# Description: Unified entry point for core, modern, and network toolsets
# Scope: Home Manager
# ---

{ ... }: {
  imports = [
    ./core.nix
    ./modern.nix
    ./network.nix
  ];
}
