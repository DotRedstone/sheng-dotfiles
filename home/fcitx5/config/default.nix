# ---
# Module: Fcitx5 Global Config
# Description: Hotkeys and behavior settings
# Scope: Home Manager
# ---

# ---
# Module: Fcitx5 Config Entry
# Description: Main configuration generator for ~/.config/fcitx5/config
# ---

{ ... }:
let
  hotkeys = (import ./hotkeys.nix { }).hotkeys;
  behavior = (import ./behavior.nix { }).behavior;
in
{
  home.file.".config/fcitx5/config" = {
    force = true;
    text = ''
      ${hotkeys}
      ${behavior}
    '';
  };
}
