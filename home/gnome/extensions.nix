# ---
# Module: GNOME Shell Touch Extensions
# Description: Tablet-friendly GNOME Shell extensions and defaults
# Scope: Home Manager
# ---

{ pkgs, ... }:
let
  extensions = with pkgs.gnomeExtensions; [
    appindicator
    caffeine
    quick-settings-tweaker
    tiling-assistant
  ];
in
{
  programs.gnome-shell = {
    enable = true;
    extensions = map (package: { inherit package; }) extensions;
  };

  dconf.settings = {
    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      notifications-enabled = true;
      notifications-compact = false;
      notifications-show-scrollbar = true;
      media-enabled = true;
      media-compact = false;
      volume-mixer-enabled = true;
      volume-mixer-only-playing = false;
      volume-mixer-show-scrollbar = true;
      input-always-show = true;
      input-show-selected = true;
      output-show-selected = true;
      dnd-quick-toggle-enabled = true;
    };

    "org/gnome/shell/extensions/caffeine" = {
      show-toggle = true;
      show-indicator = "only-active";
      enable-fullscreen = true;
      restore-state = true;
    };

    "org/gnome/shell/extensions/tiling-assistant" = {
      enable-tiling-popup = true;
      enable-raise-tile-group = true;
      window-gap = 8;
      single-screen-gap = 8;
      maximize-with-gap = false;
    };
  };
}
