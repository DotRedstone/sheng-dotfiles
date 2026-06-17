# ---
# Module: WeChat Switchboard
# Description: Unified entry point for WeChat packages, entry, and bridge
# Scope: Home Manager
# ---

{ lib, pkgs, ... }: {
  imports = lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
    ./packages.nix
    ./desktop-entry.nix
    ./notify-bridge.nix
  ];
}
