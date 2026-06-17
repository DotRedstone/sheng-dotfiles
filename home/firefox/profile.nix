# ---
# Module: Firefox - Profile
# Description: Main Firefox profile definition and global settings
# Scope: Home Manager
# ---

{ config, ... }: {
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    languagePacks = [ "zh-CN" ];
    profiles.dot = {
      id = 0;
      isDefault = true;
      name = "dot";
    };
  };
}
