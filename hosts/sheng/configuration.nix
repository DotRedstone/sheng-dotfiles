# ---
# Module: Personal System Configuration
# Description: Override and extend the upstream BSP with personal system settings
# Scope: System
# ---
{ config, pkgs, ... }:

{
  # 网络与时区
  networking.hostName = "nixos-sheng";
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";

  # 字体配置 (如果你需要安装私人中文字体、编程字体等)
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    # fira-code
  ];

  # 全局系统包 (这里只装最底层的必备工具，应用软件建议丢进 home.nix)
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
  ];

  # 你还可以在这里添加其他系统级的服务
  # 比如 SSH、Docker、Tailscale 等
  # services.openssh.enable = true;

  # 不要修改这里的 stateVersion
  system.stateVersion = "24.05";
}
