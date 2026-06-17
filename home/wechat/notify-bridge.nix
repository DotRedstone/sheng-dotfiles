# ---
# Module: WeChat Notify Bridge
# Description: Systemd user service for the WeChat notification bridge
# Scope: Home Manager
# ---

{ pkgs, ... }:
let
  wechat = pkgs.callPackage ./package.nix { };
in
{
  systemd.user.services.wechat-notify-bridge = {
    Unit = {
      Description = "Bridge WeChat activity into desktop notifications";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${wechat.notifyBridge}/bin/wechat-notify-bridge";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
