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
}
