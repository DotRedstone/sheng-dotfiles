# ---
# Module: Sheng Waydroid
# Description: Enables Android app container support for tablet-first apps
# Scope: System
# ---

{ pkgs, ... }:

{
  # Prefer Android WeChat through Waydroid on sheng/aarch64. The Linux UOS
  # client is x86_64-only in this dotfiles profile.
  virtualisation.waydroid.enable = true;

  environment.systemPackages = [
    pkgs.waydroid
  ];
}
