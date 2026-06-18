# ---
# Module: WeChat Packages
# Description: Official WeChat for Linux client packages
# Scope: Home Manager
# ---

{ lib, pkgs, ... }:
let
  wechat = pkgs.callPackage ./package.nix { };
in {
  home.packages = [
    pkgs.libnotify
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.wechat
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
    wechat.notifyBridge
  ];
}
