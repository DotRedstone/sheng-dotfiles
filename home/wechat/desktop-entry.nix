# ---
# Module: WeChat Desktop Entry
# Description: XDG desktop entry for WeChat UOS
# Scope: Home Manager
# ---

{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 {
  xdg.desktopEntries."com.tencent.wechat" = {
    name = "WeChat UOS";
    genericName = "WeChat UOS";
    comment = "WeChat UOS desktop client";
    exec = "wechat-uos -- %U";
    icon = "com.tencent.wechat";
    terminal = false;
    categories = [ "Chat" ];
    startupNotify = true;
    settings = {
      StartupWMClass = "wechat";
    };
  };
}
