# ---
# Module: Chinese Input Method
# Description: Provide the IBus LibPinyin engine for GNOME sessions
# Scope: Host
# ---
{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      libpinyin
    ];
  };
}
