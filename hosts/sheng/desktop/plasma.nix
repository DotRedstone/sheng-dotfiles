# KDE Plasma 6 Desktop Configuration
{ pkgs, ... }: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Exclude unnecessary KDE packages to save memory
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
    elisa
  ];

  # === 平板触屏体验优化 ===
  # 开启 KDE Connect，方便与手机/其他设备互联
  programs.kdeconnect.enable = true;

  # 安装 Maliit 虚拟键盘，解决 Wayland 下点按输入框不弹键盘的问题
  environment.systemPackages = with pkgs; [
    maliit-keyboard
  ];
}
