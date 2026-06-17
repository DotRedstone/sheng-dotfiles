# ---
# Module: WeChat Packages
# Description: Official WeChat for Linux client and notification bridge packages
# Scope: Home Manager
# ---

{ pkgs, ... }:
let
  wechat = pkgs.callPackage ./package.nix { };
in
{
  home.packages = [
    wechat.wechat-uos
    wechat.notifyBridge
    pkgs.libnotify
  ];
}
