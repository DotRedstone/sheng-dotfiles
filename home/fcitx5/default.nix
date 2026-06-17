# ---
# Module: Fcitx5 Switchboard
# Description: Unified entry point for Fcitx5 environment, config, Rime, and themes
# Scope: Home Manager
# ---

{ ... }: {
  imports = [
    ./env.nix
    ./config
    ./rime
    ./theme.nix
  ];
}
