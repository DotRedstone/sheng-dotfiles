# ---
# Module: Nautilus Packages
# Description: Core file manager, preview, archive, image, and document tools
# Scope: Home Manager
# ---

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    sushi
    loupe
    evince
    gnome-autoar
    file-roller
  ];
}
