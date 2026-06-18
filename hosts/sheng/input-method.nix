# ---
# Module: Chinese Input Method
# Description: Provide Fcitx5 with Rime for GNOME sessions
# Scope: Host
# ---
{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs.qt6Packages; [
      fcitx5-chinese-addons
      fcitx5-configtool
      fcitx5-gtk
      fcitx5-rime
    ];
  };
}
