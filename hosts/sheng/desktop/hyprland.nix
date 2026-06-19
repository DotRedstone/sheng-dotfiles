# Hyprland Desktop Configuration (Tiling Wayland Compositor)
{ pkgs, ... }: {
  programs.hyprland.enable = true;

  # Essential packages for a minimal Hyprland session
  environment.systemPackages = with pkgs; [
    waybar        # status bar
    dunst         # notification daemon
    wofi          # app launcher
    swaybg        # wallpaper
    wvkbd         # Wayland 虚拟键盘 (供触屏使用: wvkbd-mobintl -L 300)
  ];
}
