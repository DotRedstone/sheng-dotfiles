# ---
# Module: WeChat Packages
# Description: Official WeChat for Linux client and notification bridge packages
# Scope: Home Manager
# ---

{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 (let
  wechat = pkgs.callPackage ./package.nix { };
in {
  home.packages = [
    wechat.wechat-uos
    wechat.notifyBridge
    pkgs.libnotify
  ];
})
